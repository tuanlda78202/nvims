return {
	"hedyhli/outline.nvim",
	cmd = "Outline",
	keys = {
		{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle Outline" },
	},
	config = function()
		require("outline").setup({
			outline_window = {
				position = "right",
				width = 30,
				relative_width = true,
			},
		})
	end,
}
