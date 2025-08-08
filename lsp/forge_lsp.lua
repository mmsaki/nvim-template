return {
  name = "Forge Lsp",
  -- Run `foundryup -i nightly`
  -- Nigthly version to access forge lint
  cmd = { "/Users/meek/Developer/foundry/target/debug/forge", "lsp" },
  root_dir = vim.fs.root(0, { "foundry.toml", ".git" }),
  filetypes = { "solidity" },
  root_markers = { "foundry.toml", ".git" },
}
-- TODO: This is a
-- very long
-- comment (just imagine it)
