return {
  cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
  filetpes = { "solidity" },
  root_markers = { "foundry.toml", ".git" },
  on_attach = function(args)
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true }),
      callback = function()
        vim.cmd("silent! !forge fmt")
        vim.cmd("e!")
      end,
    })
  end,
}
