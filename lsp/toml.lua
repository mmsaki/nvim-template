return {
  cmd = { "taplo", "lsp", "stdio" },
  filetypes = { "toml" },
  single_file_support = true,
  on_attach = function(_, _)
    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        vim.lsp.buf.format()
      end,
    })
  end,
}
