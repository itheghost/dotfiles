require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "enter command mode" })
map("n", "<leader>.", "<cmd>edit ~/.config/nvim/lua/chadrc.lua<CR>", { desc = "open the config"})
map("i", "jk", "<ESC>", { desc = "exit insert mode"})

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
