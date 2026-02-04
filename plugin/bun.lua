local runner = require("runner")
vim.api.nvim_create_user_command("Bun", function(opts)

  runner.run("bun", opts.fargs, {
    persistent = true,
    name = "Bun",
  })
end, { nargs = "*" })
