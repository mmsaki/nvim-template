local set = vim.keymap.set
local opts = { noremap = true, silent = true }

set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Got to methods remapping
set("n", "]m", "]mzz")
set("n", "[m", "[mzz")

-- navigating panes
set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- indenting
set("v", "<", "<gv", { desc = "Indent backwards" })
set("v", ">", ">gv", { desc = "Indent forwards" })

-- save file
set("n", "<leader>w", ":w<CR>", { desc = "Save file", silent = true })
set("n", "<leader>x", ":so<CR>", opts)
set("n", "<leader>q", ":q<CR>", opts)
set("n", "<D-s>", ":w<CR>", { desc = "Save file", silent = true })

-- buffer navigation
set("n", "<leader><leader>h", ":bn<CR>", { desc = "Move to next buffer" })
set("n", "<leader><leader>l", ":bp<CR>", { desc = "Move to previous buffer" })

-- Move Lines
set(
  "n",
  "<D-k>",
  "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==",
  { desc = "Move Up" }
)
set(
  "n",
  "<D-j>",
  "<cmd>execute 'move .+' . v:count1<cr>==",
  { desc = "Move Down" }
)
set("i", "<D-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
set("i", "<D-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
set(
  "v",
  "<D-j>",
  ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",
  { desc = "Move Down" }
)
set(
  "v",
  "<D-k>",
  ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv",
  { desc = "Move Up" }
)

-- oil file explorer
set("n", "<leader>t", "<CMD>Oil<CR>", { desc = "Open file explorer (Oil)", noremap = true, silent = true })
set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory (Oil)", noremap = true, silent = true })

-- lspsaga
set("n", "<leader>j", ":Lspsaga diagnostic_jump_next<cr>")
set("n", "<leader>k", ":Lspsaga diagnostic_jump_prev<cr>")

-- Terminal escape
set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit Terminal mode" })

-- DAP (Debug Adapter Protocol) keymaps
-- Requires nvim-dap. For Solidity: place cursor on test name, then <leader>dl
local dap_ok, dap = pcall(require, 'dap')
if dap_ok then
  set("n", "<leader>dl", dap.continue,          { desc = "[D]ebug: [L]aunch / Continue" })
  set("n", "<leader>db", dap.toggle_breakpoint,  { desc = "[D]ebug: Toggle [B]reakpoint" })
  set("n", "<leader>do", dap.step_over,          { desc = "[D]ebug: Step [O]ver" })
  set("n", "<leader>di", dap.step_into,          { desc = "[D]ebug: Step [I]nto" })
  set("n", "<leader>dO", dap.step_out,           { desc = "[D]ebug: Step [O]ut" })
  set("n", "<leader>dB", dap.step_back,          { desc = "[D]ebug: Step [B]ack" })
  set("n", "<leader>dr", dap.restart,            { desc = "[D]ebug: [R]estart" })
  set("n", "<leader>dq", dap.terminate,          { desc = "[D]ebug: [Q]uit / Terminate" })
  set("n", "<leader>dR", dap.repl.open,          { desc = "[D]ebug: Open [R]EPL console" })
end
