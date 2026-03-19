return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		current_line_blame = true,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 500,
			ignore_whitespace = false,
		},
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
			end

			map("n", "]h", gs.next_hunk, "Next Hunk")
			map("n", "[h", gs.prev_hunk, "Prev Hunk")

			map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
			map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
			map("v", "<leader>gs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Stage hunk")
			map("v", "<leader>gr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Reset hunk")

			map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
			map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")

			map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")

			map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")

			map("n", "<leader>gb", function()
				gs.blame_line({ full = true })
			end, "Blame line")
			map("n", "<leader>gT", gs.toggle_current_line_blame, "Toggle line blame")

			map("n", "<leader>gd", gs.diffthis, "Diff this")
			map("n", "<leader>gD", function()
				gs.diffthis("~")
			end, "Diff this ~")

			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
		end,
	},
}
