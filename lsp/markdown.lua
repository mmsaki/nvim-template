-- requires markdownlin in $PATH
-- brew install markdownlint-cli2
return {
  cmd = { "markdown-oxide" },
  root_markers = { ".git" },
  filetypes = { "markdown", "markdownreact", "mdx" },
  on_attach = function(_, bufnr)
    local group_name = "MarkdownFormat_" .. bufnr
    local group = vim.api.nvim_create_augroup(group_name, { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = group,
      buffer = bufnr,
      callback = function()
        vim.cmd("silent! !markdownlint-cli2 --fix %:p")
        vim.cmd("edit!")
        -- print("[MarkdownLint-cli2] formatted buffer " .. bufnr)
      end,
    })
  end,
}
