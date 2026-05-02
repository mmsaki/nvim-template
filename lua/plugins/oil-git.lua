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
  end,
}
