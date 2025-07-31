-- requires vscode-json-language-server in $PATH
-- brew install vscode-langservers-extracted
return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {
      analysis = {
        diagnosticMode = "openFilesOnly",
      },
    },
  },
  on_attach = function(_, _)
    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        vim.lsp.buf.format()
      end,
    })
  end,
}
