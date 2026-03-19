return {
	"folke/which-key.nvim",
	cmd = "WhichKey",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {},
}
