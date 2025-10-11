-- configurations for all tables found in lsp/<name>.lua
vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
  },
  root_markers = { ".git" },
})

vim.lsp.enable("c")
vim.lsp.enable("forge_lsp")
vim.lsp.enable("js")
-- vim.lsp.enable("json")
vim.lsp.enable("luals")
vim.lsp.enable("markdown")
vim.lsp.enable("pyright")
vim.lsp.enable("ruff")
vim.lsp.enable("rust")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("toml")
vim.lsp.enable("ty")
vim.lsp.enable("swift")
vim.lsp.enable("biome")
-- vim.lsp.enable("wake_lsp")
-- vim.lsp.enable("solidity_ls_nomicfoundation")
-- vim.lsp.enable("solc")

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
            group = "kickstart-lsp-highlight",
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
