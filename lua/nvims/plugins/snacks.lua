return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	config = function()
		local snacks = require("snacks")

		snacks.setup({
			bigfile = { enabled = true },
			dashboard = {
				enabled = true,
				width = 60,
				row = nil,
				col = nil,
				pane_gap = 4,
				autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
				preset = {
					keys = {
						{
							icon = " ",
							key = "f",
							desc = "Find File",
							action = ":lua Snacks.dashboard.pick('files')",
						},
						{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{
							icon = " ",
							key = "g",
							desc = "Find Text",
							action = ":lua Snacks.dashboard.pick('live_grep')",
						},
						{
							icon = " ",
							key = "r",
							desc = "Recent Files",
							action = ":lua Snacks.dashboard.pick('oldfiles')",
						},
						{
							icon = " ",
							key = "c",
							desc = "Config",
							action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
						},
						{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
						{
							icon = "󰒲 ",
							key = "L",
							desc = "Lazy",
							action = ":Lazy",
							enabled = package.loaded.lazy ~= nil,
						},
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
					header = [[
          _____                    _____                    _____                    _____                    _____          
         /\    \                  /\    \                  /\    \                  /\    \                  /\    \         
        /::\____\                /::\____\                /::\    \                /::\____\                /::\    \        
       /::::|   |               /:::/    /                \:::\    \              /::::|   |               /::::\    \       
      /:::::|   |              /:::/    /                  \:::\    \            /:::::|   |              /::::::\    \      
     /::::::|   |             /:::/    /                    \:::\    \          /::::::|   |             /:::/\:::\    \     
    /:::/|::|   |            /:::/____/                      \:::\    \        /:::/|::|   |            /:::/__\:::\    \    
   /:::/ |::|   |            |::|    |                       /::::\    \      /:::/ |::|   |            \:::\   \:::\    \   
  /:::/  |::|   | _____      |::|    |     _____    ____    /::::::\    \    /:::/  |::|___|______    ___\:::\   \:::\    \  
 /:::/   |::|   |/\    \     |::|    |    /\    \  /\   \  /:::/\:::\    \  /:::/   |::::::::\    \  /\   \:::\   \:::\    \ 
/:: /    |::|   /::\____\    |::|    |   /::\____\/::\   \/:::/  \:::\____\/:::/    |:::::::::\____\/::\   \:::\   \:::\____\
\::/    /|::|  /:::/    /    |::|    |  /:::/    /\:::\  /:::/    \::/    /\::/    / ~~~~~/:::/    /\:::\   \:::\   \::/    /
 \/____/ |::| /:::/    /     |::|    | /:::/    /  \:::\/:::/    / \/____/  \/____/      /:::/    /  \:::\   \:::\   \/____/ 
         |::|/:::/    /      |::|____|/:::/    /    \::::::/    /                       /:::/    /    \:::\   \:::\    \     
         |::::::/    /       |:::::::::::/    /      \::::/____/                       /:::/    /      \:::\   \:::\____\    
         |:::::/    /        \::::::::::/____/        \:::\    \                      /:::/    /        \:::\  /:::/    /    
         |::::/    /          ~~~~~~~~~~               \:::\    \                    /:::/    /          \:::\/:::/    /     
         /:::/    /                                     \:::\    \                  /:::/    /            \::::::/    /      
        /:::/    /                                       \:::\____\                /:::/    /              \::::/    /       
        \::/    /                                         \::/    /                \::/    /                \::/    /        
         \/____/                                           \/____/                  \/____/                  \/____/         
                                                                                                                             ]],
				},
				formats = {
					icon = function(item)
						if item.file and item.icon == "file" or item.icon == "directory" then
							return M.icon(item.file, item.icon)
						end
						return { item.icon, width = 2, hl = "icon" }
					end,
					footer = { "%s", align = "center" },
					header = { "%s", align = "center" },
					file = function(item, ctx)
						local fname = vim.fn.fnamemodify(item.file, ":~")
						fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
						if #fname > ctx.width then
							local dir = vim.fn.fnamemodify(fname, ":h")
							local file = vim.fn.fnamemodify(fname, ":t")
							if dir and file then
								file = file:sub(-(ctx.width - #dir - 2))
								fname = dir .. "/…" .. file
							end
						end
						local dir, file = fname:match("^(.*)/(.+)$")
						return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } }
							or { { fname, hl = "file" } }
					end,
				},
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "startup" },
				},
			},
			indent = { enabled = true },
			input = { enabled = true },
			notifier = { enabled = false },
			picker = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			zen = { enabled = true },

			styles = {
				notification = {
					wo = { wrap = true },
				},
			},
		})

		vim.ui.input = snacks.input
		vim.ui.select = snacks.picker.select
	end,
	keys = {
		{
			"<leader><space>",
			function()
				Snacks.picker.smart()
			end,
			desc = "Smart Find Files",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>:",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command History",
		},

		{
			"<leader>gl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git Log",
		},
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Git Browse",
			mode = { "n", "v" },
		},
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},

		{
			"<leader>z",
			function()
				Snacks.zen()
			end,
			desc = "Toggle Zen Mode",
		},

		{
			"<leader>Nc",
			desc = "Open common workflow notes",
			function()
				local common = vim.fn.stdpath("config") .. "/docs/common.md"
				Snacks.win({
					file = common,
					width = 0.75,
					height = 0.85,
					wo = {
						spell = false,
						wrap = true,
						signcolumn = "no",
						statuscolumn = " ",
						conceallevel = 2,
					},
				})
			end,
		},
		{
			"<leader>Nv",
			desc = "Open Vim cheatsheet notes",
			function()
				local cheatsheet = vim.fn.stdpath("config") .. "/docs/vim.md"
				Snacks.win({
					file = cheatsheet,
					width = 0.75,
					height = 0.85,
					wo = {
						spell = false,
						wrap = true,
						signcolumn = "no",
						statuscolumn = " ",
						conceallevel = 2,
					},
				})
			end,
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end
				vim.print = _G.dd

				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle
					.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
					:map("<leader>uc")
				Snacks.toggle.treesitter():map("<leader>uT")
				Snacks.toggle
					.option("background", { off = "light", on = "dark", name = "Dark Background" })
					:map("<leader>ub")
				Snacks.toggle.inlay_hints():map("<leader>uh")
			end,
		})

		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = function()
				local colors = {
					orange = "#e69875",
					yellow = "#dbbc7f",
					green = "#a7c080",
					red = "#e67e80",
					purple = "#d699b6",
					blue = "#7fbbb3",
					fg = "#d3c6aa",
					bg = "#2d353b",
					grey = "#859289",
				}

				vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = colors.green, bold = true })
				vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = colors.yellow, bold = true })
				vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = colors.fg })
				vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = colors.green, bold = true })
				vim.api.nvim_set_hl(0, "SnacksDashboardFooter", { fg = colors.grey, italic = true })
				vim.api.nvim_set_hl(0, "SnacksDashboardFile", { fg = colors.blue })
				vim.api.nvim_set_hl(0, "SnacksDashboardProject", { fg = colors.purple })
				vim.api.nvim_set_hl(0, "SnacksDashboardSession", { fg = colors.green })
				vim.api.nvim_set_hl(0, "SnacksDashboardQuit", { fg = colors.red })
			end,
		})
		vim.schedule(function()
			vim.cmd("doautocmd ColorScheme")
		end)
	end,
}
