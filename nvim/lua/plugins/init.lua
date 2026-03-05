return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim"},
    lazy = false,
    opts = {},
  },

  {
    "wakatime/vim-wakatime", lazy = false,
  },

  -- {
  --   "aikhe/wrapped.nvim",
  --   dependencies = { "nvzone/volt" },
  --   cmd = { "WrappedNvim" },
  --   opts = {},
  -- },


  {
    "nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  },
}
