local M = {}

local state_file = vim.fn.stdpath("state") .. "/nvims-theme.txt"

local function list_theme_paths()
	return vim.api.nvim_get_runtime_file("lua/base46/themes/*.lua", true)
end

M.list = function()
	local names = {}
	for _, path in ipairs(list_theme_paths()) do
		local name = vim.fn.fnamemodify(path, ":t:r")
		table.insert(names, name)
	end
	table.sort(names)
	return names
end

M.apply = function(theme)
	local available = {}
	for _, name in ipairs(M.list()) do
		available[name] = true
	end
	if not available[theme] then
		vim.notify("Unknown theme: " .. theme, vim.log.levels.ERROR)
		return
	end

	local cfg = require("nvconfig")
	cfg.base46.theme = theme
	require("base46").load_all_highlights()

	vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
	local file = io.open(state_file, "w")
	if file then
		file:write(theme .. "\n")
		file:close()
	end

	vim.notify("Theme set to " .. theme, vim.log.levels.INFO)
end

M.open = function()
	local themes = M.list()
	if #themes == 0 then
		vim.notify("No base46 themes found", vim.log.levels.WARN)
		return
	end
	vim.ui.select(themes, { prompt = "Select NvChad theme" }, function(choice)
		if choice then
			M.apply(choice)
		end
	end)
end

return M
