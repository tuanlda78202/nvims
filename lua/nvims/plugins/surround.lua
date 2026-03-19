return {
	"kylechui/nvim-surround",
	event = { "BufReadPre", "BufNewFile" },
	version = "*",
	opts = {
		keymaps = {
			insert = false,
			insert_line = false,
			normal = "<leader>sa",
			normal_cur = false,
			normal_line = "<leader>sA",
			normal_cur_line = false,
			visual = "<leader>sa",
			visual_line = "<leader>sA",
			delete = "<leader>sd",
			change = "<leader>sc",
			change_line = "<leader>sC",
		},
	},
}
