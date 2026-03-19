local state_file = vim.fn.stdpath("state") .. "/nvims-theme.txt"

local function read_saved_theme()
	local file = io.open(state_file, "r")
	if not file then
		return nil
	end
	local theme = file:read("*l")
	file:close()
	return theme
end

local saved_theme = read_saved_theme()

return {
	base46 = {
		theme = saved_theme or "everforest",
		hl_add = {},
		hl_override = {},
		integrations = {},
		changed_themes = {},
		transparency = false,
		theme_toggle = { "everforest", "tokyonight" },
	},
	ui = {
		cmp = {
			icons_left = false,
			style = "default",
			abbr_maxwidth = 60,
			format_colors = { lsp = true, icon = "󱓻" },
		},
		telescope = { style = "borderless" },
		statusline = {
			enabled = true,
			theme = "default",
			separator_style = "default",
			order = nil,
			modules = nil,
		},
		tabufline = {
			enabled = true,
			lazyload = true,
			treeOffsetFt = "NvimTree",
			order = { "treeOffset", "buffers", "tabs", "btns" },
			modules = nil,
			bufwidth = 21,
		},
	},
	term = {
		startinsert = true,
		base46_colors = true,
		winopts = { number = false, relativenumber = false },
		sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
		float = {
			relative = "editor",
			row = 0.3,
			col = 0.25,
			width = 0.5,
			height = 0.4,
			border = "single",
		},
	},
	cheatsheet = {
		theme = "grid",
		excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" },
	},
	mason = {
		pkgs = {},
		skip = {},
	},
}
