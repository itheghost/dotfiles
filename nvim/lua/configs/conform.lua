require("conform").setup({
	formatters_by_ft = {
		--lua = { "stylua" },
		python = { "black" },
		cpp = { "clang-format" },
		html = { "prettier" },
		javascript = { "prettier" },
		css = { "prettier" },
		rust = { "rustywind" },
	},
})
