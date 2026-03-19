return {
	{
		"sainnhe/everforest",
		priority = 1000,
		config = function()
			vim.g.everforest_background = "soft"
			vim.g.everforest_better_performance = 1
			vim.g.everforest_enable_italic = 1
			vim.g.everforest_transparent_background = 0

			vim.cmd("colorscheme everforest")

			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "everforest",
				callback = function()
					local colors = {
						terminal_color_0 = "#2d353b",
						terminal_color_1 = "#e67e80",
						terminal_color_2 = "#a7c080",
						terminal_color_3 = "#dbbc7f",
						terminal_color_4 = "#7fbbb3",
						terminal_color_5 = "#d699b6",
						terminal_color_6 = "#83c092",
						terminal_color_7 = "#d3c6aa",

						terminal_color_8 = "#859289",
						terminal_color_9 = "#e67e80",
						terminal_color_10 = "#a7c080",
						terminal_color_11 = "#dbbc7f",
						terminal_color_12 = "#7fbbb3",
						terminal_color_13 = "#d699b6",
						terminal_color_14 = "#83c092",
						terminal_color_15 = "#d3c6aa",
					}

					for color, value in pairs(colors) do
						vim.g[color] = value
					end

					vim.g.terminal_color_8 = "#a7a7a7"
				end,
			})

			vim.schedule(function()
				vim.cmd("doautocmd ColorScheme everforest")
			end)
		end,
	},
}
