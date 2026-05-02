return {
  "refractalize/oil-git-status.nvim",
  dependencies = {
    "stevearc/oil.nvim",
  },
  config = function()
    require("oil").setup({
      win_options = {
        signcolumn = "yes:2",
      },
    })
    require("oil-git-status").setup()
    for _, hl_group in pairs(require("oil-git-status").highlight_groups) do
      if hl_group.index then
        vim.api.nvim_set_hl(0, hl_group.hl_group, { fg = "#00ff00" })
      else
        -- vim.api.nvim_set_hl(0, hl_group.hl_group, { fg = "#ff0000" })
      end
    end
  end,
}
