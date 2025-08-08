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
vim.lsp.enable("ty")
vim.lsp.enable("json")
vim.lsp.enable("toml")
-- vim.lsp.enable("solidity_ls_nomicfoundation")
-- vim.lsp.enable("wake_lsp")
-- vim.lsp.enable("solc")
vim.lsp.enable("forge_lsp")
