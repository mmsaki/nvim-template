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

vim.lsp.enable("luals")
vim.lsp.enable("markdown")
vim.lsp.enable("pyright")
vim.lsp.enable("ruff")
vim.lsp.enable("json")
vim.lsp.enable("toml")
-- vim.lsp.enable("solidity_ls_nomicfoundation")
-- vim.lsp.enable("solc")
vim.lsp.enable("foundry_lsp")
vim.lsp.enable("ty")
