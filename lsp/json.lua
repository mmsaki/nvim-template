-- requires vscode-json-language-server in $PATH
-- brew install vscode-langservers-extracted
return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  init_options = {
    provideFormatter = false,
  },
  settings = {
    json = {
      analysis = {
        diagnosticMode = "openFilesOnly",
      },
    },
  },
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.json", "*.jsonc" },
      callback = function()
        -- vim.cmd("silent JsonFormatFile")
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local content = table.concat(lines, "\n") .. "\n"
        local python_code = [[import json, sys
content = sys.stdin.read()
try:
    data = json.loads(content)
    print(json.dumps(data, indent=2))
except:
    print(content)
]]
        local result = vim.fn.system({ "python3", "-c", python_code }, content)
        if vim.v.shell_error == 0 then
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(result, "\n"))
        end
      end,
    })
  end,
}

