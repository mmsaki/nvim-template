return {
  "plankevm/plank.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
  },
}
