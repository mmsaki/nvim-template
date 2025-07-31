return {
  cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
  filetypes = { "solidity" },
  root_markers = { "foundry.toml", ".git" },
  capabilities = {
    textDocument = {
      declaration = {
        linkSupport = false,
        dynamicRegistration = false,
      },
      definition = {
        linkSupport = false,
        dynamicRegistration = false,
      },
      typeDefinition = {
        linkSupport = false,
        dynamicRegistration = false,
      },
      implementation = {
        linkSupport = false,
        dynamicRegistration = false,
      },
    },
  },
}
