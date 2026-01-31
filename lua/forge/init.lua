local M = {}

local function find_root()
  local found = vim.fs.find("foundry.toml", { upward = true })[1]
  if not found then return nil end
  return vim.fs.dirname(found)
end

function M.run(args)
  local root = find_root()
  if not root then
    vim.notify("No foundry.toml found", vim.log.levels.WARN)
    return
  end

  local half_height = math.floor(vim.o.lines / 2)

  vim.cmd("topleft " .. half_height .. "new")

  local buf = vim.api.nvim_get_current_buf()

  vim.api.nvim_buf_set_name(buf, "Forge Output")

  vim.fn.termopen({ "forge", table.unpack(args) }, { cwd = root })
end

return M
