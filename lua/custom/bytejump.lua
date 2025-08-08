return {
  "bytejump",
  name = "👀 bytejump",
  dir = "~/.config/nvim/lua/bytejump",
  dev = true,
  config = function()
    local bj = require("bytejump")

    -- :ByteJump 10       " move to the 10th bytes from start of file
    -- :ByteJump          " prompt for value
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

    -- :ByteSkip 10       " move 10 bytes forward
    -- :ByteSkip -20      " move 20 bytes back
    -- :ByteSkip          " prompt for value
    vim.api.nvim_create_user_command("ByteSkip", function(opts)
      local delta = opts.args
      if delta == "" then
        require("bytejump").prompt_and_skip()
      else
        require("bytejump").byte_skip(delta)
      end
    end, {
      nargs = "?",
      desc = "Move cursor by N bytes from current position",
    })
  end,
}
