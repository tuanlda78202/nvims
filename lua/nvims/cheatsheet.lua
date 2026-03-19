local M = {}

local state = {
	buf = nil,
	win = nil,
}

local mode_labels = {
	n = "N",
	i = "I",
	v = "V",
	x = "X",
	o = "O",
	t = "T",
	c = "C",
}

local group_order = {
	"Find",
	"Explorer",
	"Git",
	"Tabs",
	"Window",
	"Split",
	"LSP",
	"Trouble",
	"Session",
	"Terminal",
	"UI",
	"Edit",
	"Misc",
	"Core",
}

local prefix_group = {
	f = "Find",
	e = "Explorer",
	g = "Git",
	t = "Tabs",
	w = "Window",
	s = "Split",
	x = "Trouble",
	l = "LSP",
	r = "LSP",
	h = "Terminal",
	v = "Terminal",
	p = "Terminal",
	u = "UI",
	c = "Edit",
	m = "Misc",
	n = "Misc",
	o = "Misc",
}

local function normalize_lhs(lhs)
	return lhs:gsub("<leader>", "SPC "):gsub("<CR>", "Enter"):gsub("<Tab>", "Tab")
end

local function map_group(lhs)
	if lhs:sub(1, 8) == "<leader>" then
		local key = lhs:sub(9, 9)
		return prefix_group[key] or "Misc"
	end

	return "Core"
end

local function unique_maps()
	local picked = {}
	local groups = {}
	local modes = { "n", "i", "v", "x", "o", "t", "c" }

	local function add_map(mode, map)
		if map.sid == 0 then
			return
		end
		if not map.lhs or map.lhs == "" then
			return
		end

		local desc = map.desc and map.desc ~= "" and map.desc or map.rhs
		if not desc or desc == "" then
			return
		end

		local lhs = normalize_lhs(map.lhs)
		local uniq = mode .. "::" .. lhs .. "::" .. desc
		if picked[uniq] then
			return
		end
		picked[uniq] = true

		local group = map_group(map.lhs)
		groups[group] = groups[group] or {}
		table.insert(groups[group], {
			key = lhs,
			mode = mode_labels[mode] or mode,
			desc = desc,
		})
	end

	for _, mode in ipairs(modes) do
		for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
			add_map(mode, map)
		end

		for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(bufnr) then
				for _, map in ipairs(vim.api.nvim_buf_get_keymap(bufnr, mode)) do
					add_map(mode, map)
				end
			end
		end
	end

	for _, items in pairs(groups) do
		table.sort(items, function(a, b)
			if a.key == b.key then
				return a.mode < b.mode
			end
			return a.key < b.key
		end)
	end

	return groups
end

local function section_lines(name, items)
	local lines = { " " .. name, string.rep("─", 36) }

	for i = 1, #items do
		local item = items[i]
		local left = string.format(" %-3s %-18s ", item.mode, item.key)
		local text = left .. item.desc
		table.insert(lines, text)
	end

	return lines
end

local function build_grid(groups)
	local sections = {}

	for _, name in ipairs(group_order) do
		if groups[name] and #groups[name] > 0 then
			table.insert(sections, section_lines(name, groups[name]))
			groups[name] = nil
		end
	end

	local extra = {}
	for name, items in pairs(groups) do
		table.insert(extra, { name = name, items = items })
	end
	table.sort(extra, function(a, b)
		return a.name < b.name
	end)
	for _, group in ipairs(extra) do
		table.insert(sections, section_lines(group.name, group.items))
	end

	local cols = 3
	local gap = "   "
	local col_width = 52
	local rows = math.ceil(#sections / cols)
	local lines = {}

	table.insert(lines, " Nvims Cheatsheet")
	table.insert(lines, " <leader> = Space | q or <Esc> to close")
	table.insert(lines, "")

	for row = 1, rows do
		local blocks = {}
		local max_height = 0

		for col = 1, cols do
			local idx = (row - 1) * cols + col
			blocks[col] = sections[idx] or {}
			max_height = math.max(max_height, #blocks[col])
		end

		for i = 1, max_height do
			local parts = {}
			for col = 1, cols do
				local cell = blocks[col][i] or ""
				parts[col] = cell .. string.rep(" ", math.max(col_width - #cell, 0))
			end
			table.insert(lines, table.concat(parts, gap))
		end

		table.insert(lines, "")
	end

	return lines
end

local function open_window(lines)
	local width = math.min(math.floor(vim.o.columns * 0.95), 170)
	local height = math.min(math.floor(vim.o.lines * 0.9), #lines + 2)
	local row = math.floor((vim.o.lines - height) / 2 - 1)
	local col = math.floor((vim.o.columns - width) / 2)

	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].filetype = "nvims-cheatsheet"

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		row = math.max(row, 1),
		col = col,
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
		title = " Keymap Cheatsheet ",
		title_pos = "center",
	})

	vim.wo[win].wrap = false
	vim.wo[win].cursorline = false
	vim.wo[win].number = false
	vim.wo[win].relativenumber = false
	vim.wo[win].signcolumn = "no"

	vim.keymap.set("n", "q", function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end, { buffer = buf, nowait = true, silent = true })

	vim.keymap.set("n", "<Esc>", function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end, { buffer = buf, nowait = true, silent = true })

	state.buf = buf
	state.win = win
end

function M.open()
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_set_current_win(state.win)
		return
	end

	local groups = unique_maps()
	local lines = build_grid(groups)
	open_window(lines)
end

function M.toggle()
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_close(state.win, true)
		state.win = nil
		state.buf = nil
		return
	end

	M.open()
end

vim.api.nvim_create_user_command("NvimsCheatsheet", function()
	M.toggle()
end, { desc = "Toggle Nvims cheatsheet" })

return M
