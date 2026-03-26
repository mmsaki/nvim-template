return {
  name = "Solidity Language Server",
  -- cmd = { "/Users/meek/.solidity-lsp/0.1.20/bin/solidity-language-server", "--stdio" },
  cmd = {
    "/Users/meek/developer/mmsaki/solidity-language-server/target/release/solidity-language-server",
    "--stdio",
  },
  -- cmd = {
  --   "/Users/meek/developer/mmsaki/solidity-lsp-zig/zig-out/bin/solidity_lsp_zig",
  -- },
  -- cmd = {
  --   "/Users/meek/developer/mmsaki/solidity-lsp-py/.venv/bin/solidity-lsp-py",
  -- },
  filetypes = { "solidity" },
  root_markers = { "foundry.toml", ".git" },
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
  settings = {
    ["solidity-language-server"] = {
      inlayHints = {
        parameters = true,
        gasEstimates = true,
      },
      lint = {
        enabled = true,
        severity = {},
        only = {},
        exclude = {
          "unwrapped-modifier-logic",
          "screaming-snake-case-const",
          "screaming-snake-case-immutable",
        },
      },
      fileOperations = {
        templateOnCreate = true,
        updateImportsOnRename = true,
        updateImportsOnDelete = true,
      },
      projectIndex = {
        fullProjectScan = true,
        cacheMode = "v2",
        includeLibs = true,
      },
    },
  },
  on_attach = function(client, bufnr)
    -- Enable inlay hints automatically
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

    -- NOTE: BufWritePost allows client to save first, then run lsp formatting
    vim.api.nvim_create_autocmd("BufWritePost", {
      callback = function()
        -- vim.lsp.buf.format()
      end,
    })

    vim.lsp.completion.enable(true, client.id, bufnr, {
      autotrigger = true,
      convert = function(item)
        return { abbr = item.label:gsub("%b()", "") }
      end,
    })

    for _, char in ipairs({ "(", ",", "[" }) do
      vim.keymap.set("i", char, function()
        vim.api.nvim_feedkeys(char, "n", false)
        vim.defer_fn(vim.lsp.buf.signature_help, 50)
      end, { buffer = bufnr })
    end
  end,
}
