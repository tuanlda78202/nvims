return {
	"hedyhli/outline.nvim",
	cmd = "Outline",
	keys = {
		{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle Outline" },
	},
	config = function()
		require("outline").setup({
		})
	end,
}
