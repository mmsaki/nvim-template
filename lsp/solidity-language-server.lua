return {
  name = "Solidity Language Server",
  -- cmd = { "solidity-language-server", "--stdio" },
  cmd = {
    "/Users/meek/developer/asyncswap/solidity-language-server/target/release/solidity-language-server",
    "--stdio",
  },
  filetypes = { "solidity" },
  root_markers = { "foundry.toml", ".git" },
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
    workspace = {
      fileOperations = {
        willCreate = true,
        didCreate = true,
        willRename = true,
        didRename = true,
        willDelete = true,
        didDelete = true,
      },
    },
  },
  settings = {
    ["solidity-language-server"] = {
      inlayHints = {
        parameters = true,
        gasEstimates = true,
      },
      lint = {
        enabled = true,
        severity = {},
        only = {},
        exclude = {
          "unwrapped-modifier-logic",
          "screaming-snake-case-const",
          "screaming-snake-case-immutable",
          "asm-keccak256",
        },
      },
      fileOperations = {
        templateOnCreate = true,
        updateImportsOnRename = true,
        updateImportsOnDelete = true,
      },
      projectIndex = {
        fullProjectScan = true,
        cacheMode = "v2",
        incrementalEditReindex = false,
      },
    },
  },
  on_attach = function(client, bufnr)
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

    vim.api.nvim_create_autocmd("BufWritePost", {
      callback = function()
        vim.lsp.buf.format()
      end,
    })

    vim.lsp.completion.enable(true, client.id, bufnr, {
      autotrigger = true,
      convert = function(item)
        return { abbr = item.label:gsub("%b()", "") }
      end,
    })

    for _, char in ipairs({ "(", ",", "[" }) do
      vim.keymap.set("i", char, function()
        vim.api.nvim_feedkeys(char, "n", false)
        vim.defer_fn(vim.lsp.buf.signature_help, 50)
      end, { buffer = bufnr })
    end
  end,
}
