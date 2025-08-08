return {
  -- NOTE: Additonally from this you have to startm anually
  -- Make sure you run wake lsp in a separate terminal
  -- Otherwise lsp will not connect
  -- They use socket connection at port 65432
  cmd = { "nc", "localhost", "65432" },
  filetypes = { "solidity" },
  root_markers = { ".git" },
  settings = {
    wake = {
      configuration = {
        use_toml_if_present = true,
        toml_path = "wake.toml",
      },
      lsp = {
        compilation_delay = 15,
        find_references = {
          include_declarations = true,
        },
        code_lens = {
          enable = false,
        },
        detectors = {
          only = {},
        },
      },
    },
  },
}
