return {
  name = "Solidity Language Server",
  -- cmd = { "/Users/meek/.solidity-lsp/0.1.20/bin/solidity-language-server", "--stdio" },
  -- cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
  cmd = {
    "/Users/meek/developer/mmsaki/solidity-language-server/target/release/solidity-language-server", "--stdio"
  },
  filetypes = { "solidity" },
  root_markers = { "foundry.toml", ".git" },
  -- init_options is sent as initializationOptions in the LSP initialize request.
  -- settings is only available via workspace/configuration pull requests.
  -- Both are supported by the server; init_options ensures settings are
  -- available immediately at startup.
  init_options = {
    ["solidity-language-server"] = {
      inlayHints = {
        parameters = true,
        gasEstimates = true,
      },
      lint = {
        enabled = true,
        severity = {},
        only = {},
        exclude = {"unwrapped-modifier-logic", "screaming-snake-case-const"},
      },
      fileOperations = {
        templateOnCreate = true,
        updateImportsOnRename = true,
        updateImportsOnDelete = true,
      },
      projectIndex = {
        fullProjectScan = true,
        cacheMode = "v1",
        includeLibs = true,
      },
    },
  },
  on_attach = function(client, bufnr)
    -- Enable inlay hints automatically
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

    -- NOTE: BufWritePost allows client to save first, then run lsp formatting
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.sol" },
      callback = function()
        vim.lsp.buf.format()
      end,
    })

    vim.lsp.completion.enable(true, client.id, bufnr, {
      autotrigger = true,
      convert = function(item)
        return { abbr = item.label:gsub('%b()', '') }
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
