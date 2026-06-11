local function parse_output(proc)
  local result = proc:wait()
  local ret = {}
  if result.code == 0 then
    for line in
      vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true })
    do
      ret[line:gsub("/$", "")] = true
    end
  end
  return ret
end

local git_ignored = setmetatable({}, {
  __index = function(self, dir)
    local proc = vim.system({
      "git",
      "ls-files",
      "--ignored",
      "--exclude-standard",
      "--others",
      "--directory",
    }, {
      cwd = dir,
      text = true,
    })

    local ret = parse_output(proc)
    rawset(self, dir, ret)
    return ret
  end,
})

return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    watch_for_changes = true,
    use_default_keymaps = true,
    lsp_file_methods = {
      enabled = true,
      timeout_ms = 1000,
      autosave_changes = "all",
    },
    win_options = {
      signcolumn = "yes:2",
    },
    buf_options = {
      buflisted = false,
      bufhidden = "hide",
    },
    view_options = {
      show_hidden = true,
      is_hidden_file = function(name, bufnr)
        if name == ".." then
          return false
        end

        local dir = require("oil").get_current_dir(bufnr)
        if not dir then
          return vim.startswith(name, ".")
        end

        return vim.startswith(name, ".") or git_ignored[dir][name]
      end,
      is_always_hidden = function(name, bufnr)
        return false
      end,
    },
    git = {
      add = function(path)
        return true
      end,
      mv = function(src_path, dest_path)
        return true
      end,
      rm = function(path)
        return true
      end,
      ignore = true,
    },
    keymaps = {
      ["g?"] = { "actions.show_help", mode = "n" },
      ["<CR>"] = "actions.select",
      ["<C-s>"] = { "actions.select", opts = { vertical = true } },
      ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
      ["<C-t>"] = { "actions.select", opts = { tab = true } },
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = { "actions.close", mode = "n" },
      ["<C-l>"] = "actions.refresh",
      ["-"] = { "actions.parent", mode = "n" },
      ["_"] = { "actions.open_cwd", mode = "n" },
      ["`"] = { "actions.cd", mode = "n" },
      ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
      ["gs"] = { "actions.change_sort", mode = "n" },
      ["gx"] = "actions.open_external",
      ["g."] = { "actions.toggle_hidden", mode = "n" },
      ["g\\"] = { "actions.toggle_trash", mode = "n" },
    },
  },
}
