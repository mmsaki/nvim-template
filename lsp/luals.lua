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
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
  on_attach = function(_, bufnr)
    local group_name = "StyluaFormat"
    local group = vim.api.nvim_create_augroup(group_name, { clear = true })
    local stylua = require("stylua")
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = group,
      buffer = bufnr,
      callback = function()
        stylua.format()
      end,
    })
  end,
}
