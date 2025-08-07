return {
  "bytejump",
  name = "👀 bytejump",
  dir = "~/.config/nvim/lua/bytejump",
  dev = true,
  config = function()
    local bj = require("bytejump")
    vim.api.nvim_create_user_command("ByteJump", function(opts)
      local offset = opts.args
      if offset == "" then
        bj.prompt_and_jump()
      else
        bj.goto_byte_offset(offset)
      end
    end, {
        nargs = "?",
        desc = "Jump to byte offset in current buffer",
      })
  end,
}
