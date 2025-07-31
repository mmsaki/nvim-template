return {
  cmd = { "solc", "--lsp" },
  filetypes = { "solidity" },
  root_markers = { "foundry.toml", ".git" },
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
      declaration = {
        linkSupport = true,
        dynamicRegistration = true,
      },
      definition = {
        linkSupport = true,
        dynamicRegistration = true,
      },
      typeDefinition = {
        linkSupport = true,
        dynamicRegistration = true,
      },
      implementation = {
        linkSupport = true,
        dynamicRegistration = true,
      },
    },
  },
}
