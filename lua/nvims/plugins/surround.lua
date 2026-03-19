return {
	"kylechui/nvim-surround",
	event = { "BufReadPre", "BufNewFile" },
	version = "*",
	init = function()
		vim.g.nvim_surround_no_mappings = true
	end,
	config = function()
		require("nvim-surround").setup({})

		vim.keymap.set("n", "<leader>sa", "<Plug>(nvim-surround-normal)", {
			desc = "Surround add (motion)",
		})
		vim.keymap.set("n", "<leader>sA", "<Plug>(nvim-surround-normal-line)", {
			desc = "Surround add (line)",
		})
		vim.keymap.set("x", "<leader>sa", "<Plug>(nvim-surround-visual)", {
			desc = "Surround add (selection)",
		})
		vim.keymap.set("x", "<leader>sA", "<Plug>(nvim-surround-visual-line)", {
			desc = "Surround add (selection line)",
		})
		vim.keymap.set("n", "<leader>sd", "<Plug>(nvim-surround-delete)", {
			desc = "Surround delete",
		})
		vim.keymap.set("n", "<leader>sc", "<Plug>(nvim-surround-change)", {
			desc = "Surround change",
		})
		vim.keymap.set("n", "<leader>sC", "<Plug>(nvim-surround-change-line)", {
			desc = "Surround change (line)",
		})
	end,
}
