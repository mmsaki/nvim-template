return {
  "mmsaki/forge.nvim",
  config = function()
    require("forge").setup({
      allow_standalone = false, -- optional
    })
  end,
}
