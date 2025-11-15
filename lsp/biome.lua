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
}
