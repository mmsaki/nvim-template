return {
  "hmdfrds/focal.nvim",
  event = "VeryLazy",
  dependencies = { "3rd/image.nvim" },
  opts = {},
  init = function()
    require("focal").register_source({
      filetype = "my_explorer",
      get_path = function()
        return require("my_explorer").get_file_under_cursor()
      end,
    })
  end,
}
