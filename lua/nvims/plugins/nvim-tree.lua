return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	event = "VimEnter",
	cmd = {
		"NvimTreeToggle",
		"NvimTreeFocus",
		"NvimTreeFindFileToggle",
		"NvimTreeCollapse",
		"NvimTreeRefresh",
	},
	keys = {
		{ "<leader>ef", "<cmd>NvimTreeFocus<CR>", desc = "Focus file explorer" },
		{ "<leader>ee", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
		{ "<leader>et", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Toggle file explorer on current file" },
		{ "<leader>ec", "<cmd>NvimTreeCollapse<CR>", desc = "Collapse file explorer" },
		{ "<leader>er", "<cmd>NvimTreeRefresh<CR>", desc = "Refresh file explorer" },
	},
	init = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
	end,
	config = function()
		local nvimtree = require("nvim-tree")
		local api = require("nvim-tree.api")
		local function on_attach(bufnr)
			api.config.mappings.default_on_attach(bufnr)

			vim.keymap.del("n", "<CR>", { buffer = bufnr })
			vim.keymap.set("n", "<CR>", function()
				local node = api.tree.get_node_under_cursor()
				if not node then
					return
				end
				if node.type ~= "file" then
					api.node.open.edit(node)
					return
				end

				api.node.open.tab(node)
			end, { buffer = bufnr, desc = "Open File: New Tab + Keep Explorer" })
		end

		nvimtree.setup({
			on_attach = on_attach,
			tab = {
				sync = {
					open = true,
					close = true,
				},
			},
			view = {
				width = 35,
				relativenumber = true,
			},
			renderer = {
				indent_markers = {
					enable = true,
				},
				icons = {
					glyphs = {
						folder = {
							arrow_closed = "",
							arrow_open = "",
						},
					},
				},
			},
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			filters = {
				custom = { ".DS_Store" },
			},
			git = {
				ignore = true,
			},
		})

		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function(data)
				if vim.fn.isdirectory(data.file) == 1 then
					api.tree.open()
				end
			end,
		})
	end,
}
