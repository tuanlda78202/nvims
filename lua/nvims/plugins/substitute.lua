return {
	"gbprod/substitute.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local substitute = require("substitute")

		substitute.setup()

		vim.keymap.set("n", "<leader>rr", substitute.operator, { desc = "Replace with motion" })
		vim.keymap.set("n", "<leader>rl", substitute.line, { desc = "Replace current line" })
		vim.keymap.set("n", "<leader>re", substitute.eol, { desc = "Replace to end of line" })
		vim.keymap.set("x", "<leader>rr", substitute.visual, { desc = "Replace selection" })
	end,
}
