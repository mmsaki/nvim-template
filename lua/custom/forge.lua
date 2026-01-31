return {
  "forge",
  name = "Forge",
  dir = "~/.config/nvim/lua/forge",
  dev = true,
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "solidity",
      callback = function(ev)
        vim.api.nvim_buf_create_user_command(ev.buf, "Forge", function(opts)
          if #opts.fargs == 0 then
            vim.notify("Usage: Forge <args...>", vim.log.levels.INFO)
            return
          end

          local runner = require("forge")
          runner.run(opts.fargs)
        end, {
          nargs = "+",
          complete = function() return {} end,  -- arbitrary args
        })
      end,
    })
  end,
}
