return {
	"ellisonleao/gruvbox.nvim",
	"navarasu/onedark.nvim",
	"goolord/alpha-nvim",

    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    "neovim/nvim-lspconfig",
    "nvim-lua/lsp-status.nvim",
    "hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",

	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",

	"stevearc/conform.nvim",

    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
	"MunifTanjim/nui.nvim",

    "nvim-lualine/lualine.nvim",
    "akinsho/bufferline.nvim",

	"nvim-tree/nvim-tree.lua",
	"nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",

	"lewis6991/gitsigns.nvim",

	--{ "mistricky/codesnap.nvim", build = "make build_generator" },
	
    {
    	"folke/which-key.nvim",
		event = "VeryLazy",
		keys = {
		   {
			"<leader>?",
			function()
				require("which-key").show({ global = false })	
			end,
			desc = "Buffer Local Keymaps (which-key)",
		   },
		},
    },
}

