-- Mappings
local map = vim.keymap.set

-- Nvim-tree
map('n', '<leader>t', 	"<cmd>NvimTreeToggle<CR>")
map('n', '<C-e>', 		"<cmd>NvimTreeFocus<CR>")

-- Telescope
map('n', '<leader>ff', 	"<cmd>Telescope find_files<CR>")
map('n', '<leader>fh', 	"<cmd>Telescope oldfiles<CR>")
map('n', '<leader>fg', 	"<cmd>Telescope live_grep<CR>")
map('n', '<leader>fm', 	"<cmd>Telescope marks<CR>")

-- General
map('n', '<leader>.', 	"<cmd>edit ~/.config/nvim<CR>")	-- Open the config directory
map('n', '<leader>b', 	"<cmd>bnext<CR>")			   	-- Cycle through buffers
map('n', '<leader>B', 	"<cmd>bprevious<CR>")
map('n', '<leader>d', 	"<cmd>bdelete<CR>") 		   	-- Delete buffer
map('n', '<C-s>', 		"<cmd>w<CR>")					-- Ctrl-s to save

