return {
  cmd = { "rust-analyzer" },
  root_markers = { "Cargo.toml" },
  filetypes = { "rust" },
  on_attach = function(_, bufnr)
    -- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.rs" },
      callback = function()
        vim.cmd("RustFmt")
        -- vim.lsp.buf.format()
      end,
    })
  end,
  settings = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      diagnostics = {
        enable = true,
      },
      cargo = {
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = true,
      },
      checkOnSave = true,
      rustfmt = {
        extraArgs = { "" },
        rangeFormatting = {
          enable = true,
        },
      },
      lens = {
        debug = { enable = true },
        enable = true,
        implementations = { enable = true },
        references = {
          adt = { enable = true },
          enumVariant = { enable = true },
          method = { enable = true },
          trait = { enable = true },
        },
        run = { enable = true },
        updateTest = { enable = true },
      },
    },
  },
}
