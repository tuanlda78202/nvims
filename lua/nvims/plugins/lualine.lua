return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status")

		local colors = {
			blue = "#7FBBB3",
			green = "#A7C080",
			violet = "#D699B6",
			yellow = "#DBBC7F",
			red = "#E67E80",
			orange = "#E69875",
			fg = "#D3C6AA",
			bg = "#1E2326",
			inactive_bg = "#2E383C",
			inactive_fg = "#859289",
		}

		local my_lualine_theme = {
			normal = {
				a = { bg = colors.green, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			insert = {
				a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			visual = {
				a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			command = {
				a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			replace = {
				a = { bg = colors.red, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			inactive = {
				a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
				b = { bg = colors.inactive_bg, fg = colors.semilightgray },
				c = { bg = colors.inactive_bg, fg = colors.semilightgray },
			},
		}

		local function get_python_env()
			local venv = vim.env.VIRTUAL_ENV
			if venv then
				return "🐍 " .. vim.fn.fnamemodify(venv, ":~")
			end

			return "❌ no venv"
		end

		lualine.setup({
			options = {
				theme = my_lualine_theme,
			},
			sections = {
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = colors.orange },
					},
					{
						get_python_env,
						color = function()
							if
								vim.env.VIRTUAL_ENV
								or (vim.env.CONDA_DEFAULT_ENV and vim.env.CONDA_DEFAULT_ENV ~= "base")
							then
								return { fg = colors.green }
							else
								return { fg = colors.red }
							end
						end,
					},
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
			},
		})
	end,
}
