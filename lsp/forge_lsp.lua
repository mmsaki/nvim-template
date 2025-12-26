return {
  name = "Forge Lsp",
  -- Install binary from https://crates.io/crates/forge-lsp
  -- cargo install forge-lsp
  -- cmd = { "forge-lsp" },
  -- cmd = { "/Users/meek/developer/mmsaki/lsp/target/release/forge-lsp" },
  -- cmd = { "solidity-ls", "--stdio" },
  cmd = {
    "/Users/meek/developer/mmsaki/solidity-language-server/target/release/solidity-language-server",
  },
  root_dir = vim.fs.root(0, { "foundry.toml", ".git" }),
  filetypes = { "solidity" },
  root_markers = { "foundry.toml", ".git" },
  on_attach = function(_, _)
    -- NOTE: BufWritePost allows client to save first, then run lsp formatting
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.sol" },
      callback = function()
        vim.lsp.buf.format()
      end,
    })
  end,
}
