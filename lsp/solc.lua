return {
  cmd = { "solc", "--lsp" },
  filetpes = { "solidity" },
  root_markers = { ".git" },
  on_attach = function(args)
    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        vim.cmd("silent! !forge fmt")
        vim.cmd("e!")
      end,
    })
  end,
}
