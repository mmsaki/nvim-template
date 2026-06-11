local runner = require("runner")
vim.api.nvim_create_user_command("Zig", function(opts)
  runner.run("zig", opts.fargs, {
    persistent = true,
    name = "Zig",
  })
end, { nargs = "*" })
