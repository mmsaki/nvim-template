return {
  name = "Forge Lsp",
  -- Install binary from https://crates.io/crates/forge-lsp
  -- cargo install forge-lsp
  cmd = { "forge-lsp" },
  -- cmd = { "/Users/meek/developer/lsp/target/release/forge-lsp" },
  root_dir = vim.fs.root(0, { "foundry.toml", ".git" }),
  filetypes = { "solidity" },
  root_markers = { "foundry.toml", ".git" },
}
