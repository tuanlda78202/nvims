return {
	{
		"nvchad/base46",
		lazy = false,
		priority = 1000,
		dependencies = { "nvim-lua/plenary.nvim" },
		init = function()
			vim.g.base46_cache = vim.fn.stdpath("cache") .. "/nvims/base46/"
		end,
		config = function()
			require("base46").load_all_highlights()

			vim.api.nvim_create_user_command("NvimsThemes", function()
				require("nvims.themes").open()
			end, {})

			vim.api.nvim_create_user_command("NvimsTheme", function(opts)
				require("nvims.themes").apply(opts.args)
			end, {
				nargs = 1,
				complete = function()
					return require("nvims.themes").list()
				end,
			})
		end,
		keys = {
			{
				"<leader>th",
				function()
					require("nvims.themes").open()
				end,
				desc = "Theme Picker",
			},
		},
	},
}
