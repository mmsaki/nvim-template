vim.g.zig_fmt_parse_errors = 1
vim.g.zig_fmt_autosave = 1
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.zig", "*.zon" },
  callback = function(ev)
    -- auto format
    vim.lsp.buf.format()
    -- auto fix
    -- vim.lsp.buf.code_action({
    --   context = { only = { "source.fixAll" } },
    --   apply = true,
    -- })
    -- -- organize imports
    -- vim.lsp.buf.code_action({
    --   context = { only = { "source.organizeImports" } },
    --   apply = true,
    -- })
  end,
})

return {
  cmd = { "zls" },
  filetypes = { "zig", "zir", "zon" },
  root_markers = { "zls.json", "build.zig", ".git" },
}
