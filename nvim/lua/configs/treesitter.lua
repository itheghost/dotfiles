require("nvim-treesitter").setup{
	-- All of the parsers the MUST be installed
	ensure_installed = { "c", "cpp", "bash", "css", "html", "javascript", "lua", "rust" },

	-- Install parsers synchronously
	sync_install = true,

	highlight = {
		enable = true,
		
		-- Runs :h syntax, might break highlighting
		additional_vim_regex_highlighting = false,
	},
}
