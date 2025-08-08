-- jumps to the byte offset in the current puffer
local M = {}

function M.config() end

function M.goto_byte_offset(offset)
  offset = tonumber(offset)
  if not offset or offset < 0 then
    vim.notify("Invalid byte offset", vim.log.levels.ERROR)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
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

function M.byte_skip(delta)
  delta = tonumber(delta)
  if not delta then
    vim.notify("Invalid byte delta", vim.log.levels.ERROR)
    return
  end

  -- Get current absolute byte offset
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cur_row, cur_col = cursor[1], cursor[2]

  local total_bytes = 0
  for row = 1, #lines do
    local line = lines[row]
    local line_with_nl = line .. "\n"
    if row == cur_row then
      total_bytes = total_bytes + cur_col
      break
    else
      total_bytes = total_bytes + #line_with_nl
    end
  end

  -- Apply skip
  local new_offset = total_bytes + delta
  M.goto_byte_offset(new_offset)
end

function M.prompt_and_skip()
  vim.ui.input({ prompt = "Enter byte delta (+/-): " }, function(input)
    if input then
      M.byte_skip(input)
    end
  end)
end
return M
