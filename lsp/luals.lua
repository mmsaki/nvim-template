-- Requires these in $PATH
-- brew install lua-language-server
-- brew install stylua
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  on_attach = function(_, bufnr)
    local group_name = "StyluaFormat_" .. bufnr
    local group = vim.api.nvim_create_augroup(group_name, { clear = true })
    local stylua = require("stylua")
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = group,
      buffer = bufnr,
      callback = function()
        stylua.format()
        print("[Stylua] formatted buffer " .. bufnr)
      end,
    })
  end,
}
