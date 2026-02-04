local M = {}

local persistent_bufs = {}

local function open_terminal(cmd, args, persistent, name, cwd)
  local height = math.floor(vim.o.lines / 2)

  if persistent and persistent_bufs[name] then
    local buf = persistent_bufs[name]
    if vim.api.nvim_buf_is_valid(buf) then
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf then
          vim.api.nvim_set_current_win(win)
          return
        end
      end
      vim.cmd("topleft " .. height .. "split")
      vim.api.nvim_win_set_buf(0, buf)
      return
    end
  end

  vim.cmd("topleft " .. height .. "new")
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_name(buf, name)

  if not persistent then
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
  end

  vim.fn.termopen(vim.tbl_flatten({ cmd, args or {} }), { cwd = cwd })

  if persistent then
    persistent_bufs[name] = buf
  end
end

function M.run(cmd, args, opts)
  opts = opts or {}

  local cwd = opts.cwd or vim.loop.cwd()
  local persistent = opts.persistent or false
  local name = opts.name or cmd

  open_terminal(cmd, args, persistent, name, cwd)
end

return M
