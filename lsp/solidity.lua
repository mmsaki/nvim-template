return {
  name = "Solidity Language Server",
  -- Install binary from https://crates.io/crates/forge-lsp
  -- cargo install forge-lsp
  -- cmd = { "solc", "--lsp" },
  -- cmd = { "/Users/meek/developer/mmsaki/lsp/target/release/forge-lsp" },
  -- cmd = { "solidity-ls", "--stdio" },
  -- cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
  cmd = {
    "/Users/meek/developer/mmsaki/solidity-language-server/target/release/solidity-language-server",
  },
  root_dir = vim.fs.root(0, { "foundry.toml", ".git" }),
  filetypes = { "solidity" },
  root_markers = { "foundry.toml", ".git" },
  settings = {
    ["solidity-language-server"] = {
      inlayHints = {
        parameters = true,
        gasEstimates = true,
      },
      lint = {
        enabled = true,
        severity = {},
        only = {},
        exclude = {"screaming-snake-case-const"},
      },
    },
  },
  on_attach = function(client, bufnr)
    -- Enable inlay hints automatically
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

    -- NOTE: BufWritePost allows client to save first, then run lsp formatting
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.sol" },
      callback = function()
        vim.lsp.buf.format()
      end,
    })

    vim.lsp.completion.enable(true, client.id, bufnr, {
      autotrigger = true,
      convert = function(item)
        return { abbr = item.label:gsub('%b()', '') }
      end,
    })

    for _, char in ipairs({ "(", ",", "[" }) do
      vim.keymap.set("i", char, function()
        vim.api.nvim_feedkeys(char, "n", false)
        vim.defer_fn(vim.lsp.buf.signature_help, 50)
      end, { buffer = bufnr })
    end
  end,
}
