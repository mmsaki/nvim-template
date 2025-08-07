-- jumps to the byte offset in the current puffer
local M = {}

function M.config() end

function M.goto_byte_offset(offset)
  offset = tonumber(offset)
  if not offset or offset < 0 then
    vim.notify("Invalid byte offset", vim.log.levels.ERROR)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  local total_bytes = 0

  for row, line in ipairs(lines) do
    local line_with_nl = line .. "\n"
    local line_bytes = #line_with_nl
    if total_bytes + line_bytes >= offset then
      local col = offset - total_bytes
      -- Clamp column if needed
      col = math.max(0, math.min(col, #line))
      vim.api.nvim_win_set_cursor(0, { row, col })
      return
    end
    total_bytes = total_bytes + line_bytes
  end

  vim.notify("Offset exceeds buffer length", vim.log.levels.WARN)
end

function M.prompt_and_jump()
  vim.ui.input({ prompt = "Enter byte offset: " }, function(input)
    if input then
      M.goto_byte_offset(input)
    end
  end)
end

return M
