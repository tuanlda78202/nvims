return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "tabs",
			close_command = function(n)
				if vim.fn.tabpagenr("$") > 1 then
					vim.cmd("tabclose " .. n)
				end
			end,
			right_mouse_command = function(n)
				if vim.fn.tabpagenr("$") > 1 then
					vim.cmd("tabclose " .. n)
				end
			end,
			separator_style = "slant",
		},
	},
}
