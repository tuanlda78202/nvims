return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		local comment = require("Comment")

		local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

		comment.setup({
			mappings = false,
			pre_hook = ts_context_commentstring.create_pre_hook(),
		})

		local api = require("Comment.api")
		local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)

		vim.keymap.set("n", "<leader>cl", function()
			api.toggle.linewise.current()
		end, { desc = "Comment toggle line" })

		vim.keymap.set("n", "<leader>cb", function()
			api.toggle.blockwise.current()
		end, { desc = "Comment toggle block" })

		vim.keymap.set("x", "<leader>cl", function()
			vim.api.nvim_feedkeys(esc, "nx", false)
			api.toggle.linewise(vim.fn.visualmode())
		end, { desc = "Comment toggle line" })

		vim.keymap.set("x", "<leader>cb", function()
			vim.api.nvim_feedkeys(esc, "nx", false)
			api.toggle.blockwise(vim.fn.visualmode())
		end, { desc = "Comment toggle block" })
	end,
}
