vim.cmd([[set completeopt+=menuone,noselect,popup]])
-- configurations for all tables found in lsp/<name>.lua
vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
    workspace = {
      fileOperations = {
        willCreate = true,
        didCreate = true,
        willRename = true,
        didRename = true,
        willDelete = true,
        didDelete = true,
      },
    },
  },
  root_markers = { ".git" },
})

vim.lsp.enable("biome")
vim.lsp.enable("c")
-- vim.lsp.enable("cssls")
vim.lsp.enable("solidity-language-server")
vim.lsp.enable("js")
vim.lsp.enable("luals")
vim.lsp.enable("markdown")
vim.lsp.enable("pyright")
vim.lsp.enable("ruff")
vim.lsp.enable("rust")
vim.lsp.enable("swift")
vim.lsp.enable("json")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("toml")
vim.lsp.enable("ty")
vim.lsp.enable("typos")
vim.lsp.enable("grammar")
vim.lsp.enable("zig")
-- vim.lsp.enable("wake_lsp")
-- vim.lsp.enable("solidity_ls_nomicfoundation")
-- vim.lsp.enable("solc")

-- Custom call hierarchy handlers: jump to the call-site expression
-- (fromRanges) rather than the caller/callee function definition.
vim.lsp.handlers["callHierarchy/incomingCalls"] = function(_, result, ctx)
  if not result or vim.tbl_isempty(result) then
    vim.notify("No incoming calls found", vim.log.levels.INFO)
    return
  end
  local items = {}
  for _, call in ipairs(result) do
    local caller = call.from
    local filename = vim.uri_to_fname(caller.uri)
    -- Each fromRange is a call-site expression inside the caller.
    for _, range in ipairs(call.fromRanges or {}) do
      table.insert(items, {
        filename = filename,
        lnum = range.start.line + 1,
        col = range.start.character + 1,
        text = caller.name,
      })
    end
  end
  vim.fn.setqflist({}, " ", { title = "Incoming Calls", items = items })
  vim.cmd("copen")
end

vim.lsp.handlers["callHierarchy/outgoingCalls"] = function(_, result, ctx)
  if not result or vim.tbl_isempty(result) then
    vim.notify("No outgoing calls found", vim.log.levels.INFO)
    return
  end
  -- fromRanges are in the caller item file, not the callee definition file.
  local caller_uri = ctx.params and ctx.params.item and ctx.params.item.uri
  local caller_file = caller_uri and vim.uri_to_fname(caller_uri)
    or vim.api.nvim_buf_get_name(ctx.bufnr)
  local items = {}
  for _, call in ipairs(result) do
    local callee = call.to
    for _, range in ipairs(call.fromRanges or {}) do
      table.insert(items, {
        filename = caller_file,
        lnum = range.start.line + 1,
        col = range.start.character + 1,
        text = callee.name,
      })
    end
  end
  vim.fn.setqflist({}, " ", { title = "Outgoing Calls", items = items })
  vim.cmd("copen")
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local keymap = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(
        mode,
        keys,
        func,
        { buffer = event.buf, desc = "LSP: " .. desc }
      )
    end
    keymap("grn", vim.lsp.buf.rename, "[R]e[n]ame")
    keymap("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
    keymap("grr", vim.lsp.buf.references, "[G]oto [R]eferences")
    keymap("gri", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    keymap("grd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    keymap("grt", vim.lsp.buf.type_definition, "[G]oto [T]ype Definition")
    keymap("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    keymap("gO", vim.lsp.buf.document_symbol, "Open Document Symbols")
    keymap("gW", vim.lsp.buf.workspace_symbol, "Open Workspace Symbols")
    keymap("<C-s>", vim.lsp.buf.signature_help, "Signature Help", { "i" })
    keymap("gq", vim.lsp.buf.format, "Format")
    keymap("K", vim.lsp.buf.hover, "Hover")
    keymap("<leader>i", vim.lsp.buf.incoming_calls, "Incoming calls")
    keymap("<leader>o", vim.lsp.buf.outgoing_calls, "Outgoing calls")

    local function client_supports_method(client, method, bufnr)
      if vim.fn.has("nvim-0.11") == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    if client.name == "biome" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("BiomeFixAll", { clear = true }),
        callback = function()
          -- fmt: auto format
          vim.lsp.buf.format()

          -- fix: code actions
          vim.lsp.buf.code_action({
            context = {
              only = { "source.fixAll.biome" },
              diagnostics = {},
            },
            apply = true,
          })
        end,
      })
    end

    if client.name == "rust-analyzer" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("RustCargoFmt", { clear = true }),
        pattern = "*.rs",
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    if
      client
      and client_supports_method(
        client,
        vim.lsp.protocol.Methods.textDocument_documentHighlight,
        event.buf
      )
    then
      local highlight_augroup =
        vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({
            group = "lsp-highlight",
            buffer = event2.buf,
          })
        end,
      })
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if
      client
      and client_supports_method(
        client,
        vim.lsp.protocol.Methods.textDocument_inlayHint,
        event.buf
      )
    then
      keymap("<leader>th", function()
        vim.lsp.inlay_hint.enable(
          not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
        )
      end, "[T]oggle Inlay [H]ints")
    end
  end,
})
