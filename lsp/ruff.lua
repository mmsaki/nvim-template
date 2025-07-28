return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  settings = {},
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true }),
      callback = function()
        vim.lsp.buf.format()
      end,
    })
  end,
}
