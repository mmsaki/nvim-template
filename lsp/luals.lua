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
  on_attach = function()
    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        require("stylua").format()
      end,
    })
  end,
}
