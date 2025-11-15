local util = require("lspconfig.util")

return {
  cmd = { "biome", "lsp-proxy" },
  filetypes = {
    "astro",
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    "svelte",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
    "vue",
  },
  root_markers = {
    "bun.lockb",
    "bun.lock",
    "package.json",
    ".git",
  },
  root_dir = function(fname)
    local root_files = { "biome.json", "biome.jsonc" }
    root_files = util.insert_package_json(root_files, "biome", fname)
    return vim.fs.dirname(
      vim.fs.find(root_files, { path = fname, upward = true })[1]
    )
  end,
  single_file_support = true,
  docs = {
    description = [[
https://biomejs.dev

Toolchain of the web. [Successor of Rome](https://biomejs.dev/blog/annoucing-biome).

```sh
npm install [-g] @biomejs/biome
```
]],
  },
}
