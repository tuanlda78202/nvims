local api = vim.api
local g = vim.g
local cfg = require("nvconfig").term

local M = {}

g.nvims_terms = g.nvims_terms or {}

local pos_data = {
	sp = { resize = "height", area = "lines" },
	vsp = { resize = "width", area = "columns" },
	["bo sp"] = { resize = "height", area = "lines" },
	["bo vsp"] = { resize = "width", area = "columns" },
}

local function get_win_size_for_pos(win, pos)
	if not pos_data[pos] then
		return nil
	end
	if pos_data[pos].resize == "width" then
		return api.nvim_win_get_width(win)
	end
	return api.nvim_win_get_height(win)
end

if cfg.base46_colors and vim.g.base46_cache and vim.uv.fs_stat(vim.g.base46_cache .. "term") then
	dofile(vim.g.base46_cache .. "term")
end

local function save_term_info(index, val)
	local terms = g.nvims_terms
	terms[tostring(index)] = val
	g.nvims_terms = terms
end

local function list_wins_for_buf(buf)
	local wins = {}
	for _, win in ipairs(api.nvim_list_wins()) do
		if api.nvim_win_is_valid(win) and api.nvim_win_get_buf(win) == buf then
			table.insert(wins, win)
		end
	end
	return wins
end

local function has_win_in_current_tab(buf)
	for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
		if api.nvim_win_is_valid(win) and api.nvim_win_get_buf(win) == buf then
			return true
		end
	end
	return false
end

local function opts_to_id(id)
	for _, opts in pairs(g.nvims_terms) do
		if opts and opts.id == id then
			return opts
		end
	end
end

local function create_float(buffer, float_opts)
	local opts = vim.tbl_deep_extend("force", cfg.float, float_opts or {})
	opts.width = math.ceil(opts.width * vim.o.columns)
	opts.height = math.ceil(opts.height * vim.o.lines)
	opts.row = math.ceil(opts.row * vim.o.lines)
	opts.col = math.ceil(opts.col * vim.o.columns)
	api.nvim_open_win(buffer, true, opts)
end

M.display = function(opts)
	local prev_win = api.nvim_get_current_win()
	if opts.pos == "float" then
		create_float(opts.buf, opts.float_opts)
	else
		vim.cmd(opts.pos)
	end

	local win = api.nvim_get_current_win()

	vim.bo[opts.buf].buflisted = false
	vim.bo[opts.buf].ft = "NvimsTerm_" .. opts.pos:gsub(" ", "")

	if cfg.startinsert and not opts.no_insert then
		vim.cmd("startinsert")
	end

	if opts.pos ~= "float" then
		local pos_type = pos_data[opts.pos]
		local set_size = opts.win_size
		if type(set_size) ~= "number" then
			local size = opts.size or cfg.sizes[opts.pos]
			set_size = math.floor(vim.o[pos_type.area] * size)
		end
		api["nvim_win_set_" .. pos_type.resize](0, math.max(1, set_size))
		opts.win_size = get_win_size_for_pos(win, opts.pos)
	end

	api.nvim_win_set_buf(win, opts.buf)
	local winopts = vim.tbl_deep_extend("force", cfg.winopts, opts.winopts or {})
	for k, v in pairs(winopts) do
		vim.wo[win][k] = v
	end
	vim.wo[win].signcolumn = "no"
	vim.wo[win].foldcolumn = "0"
	vim.wo[win].number = false
	vim.wo[win].relativenumber = false
	pcall(function()
		vim.wo[win].statuscolumn = ""
	end)
	if opts.pos ~= "float" then
		local resize_axis = pos_data[opts.pos].resize
		if resize_axis == "width" then
			vim.wo[win].winfixwidth = true
		elseif resize_axis == "height" then
			vim.wo[win].winfixheight = true
		end
	end

	opts.active = opts.active ~= false
	save_term_info(opts.buf, opts)

	if opts.keep_focus and api.nvim_win_is_valid(prev_win) then
		api.nvim_set_current_win(prev_win)
	end
end

local function create(opts)
	local buf_exists = opts.buf
	opts.buf = opts.buf or api.nvim_create_buf(false, true)

	local shell = vim.o.shell
	local cmd = { shell }
	if opts.cmd then
		local run = type(opts.cmd) == "string" and opts.cmd or opts.cmd()
		cmd = { shell, "-c", run .. "; " .. shell }
	end

	M.display(opts)
	opts.termopen_opts = vim.tbl_extend("force", opts.termopen_opts or {}, { detach = false })
	if not buf_exists then
		vim.fn.termopen(cmd, opts.termopen_opts)
	end
end

M.new = function(opts)
	create(opts)
end

M.toggle = function(opts)
	local existing = opts_to_id(opts.id)
	local existing_buf = existing and existing.buf or nil
	local buf_valid = existing_buf and api.nvim_buf_is_valid(existing_buf)
	local wins = buf_valid and list_wins_for_buf(existing_buf) or {}

	opts.buf = buf_valid and existing_buf or nil
	if existing and buf_valid and existing.active then
		local snapshot_win = wins[1]
		if snapshot_win and api.nvim_win_is_valid(snapshot_win) then
			existing.win_size = get_win_size_for_pos(snapshot_win, existing.pos)
		end
		for _, win in ipairs(wins) do
			if api.nvim_win_is_valid(win) then
				api.nvim_win_close(win, true)
			end
		end
		existing.active = false
		save_term_info(existing_buf, existing)
		return
	end

	opts.active = true
	if (not existing) or not buf_valid then
		create(opts)
	else
		create(vim.tbl_deep_extend("force", existing, opts))
	end
end

M.list = function()
	local items = {}
	for bufnr, term_opts in pairs(g.nvims_terms) do
		if term_opts and api.nvim_buf_is_valid(tonumber(bufnr)) then
			table.insert(items, {
				bufnr = tonumber(bufnr),
				label = term_opts.id or ("term-" .. bufnr),
				pos = term_opts.pos,
			})
		end
	end
	table.sort(items, function(a, b)
		return a.label < b.label
	end)
	return items
end

M.pick = function()
	local items = M.list()
	if #items == 0 then
		vim.notify("No tracked terminals", vim.log.levels.INFO)
		return
	end

	vim.ui.select(items, {
		prompt = "Select terminal",
		format_item = function(item)
			return string.format("%s (%s)", item.label, item.pos)
		end,
	}, function(choice)
		if choice and api.nvim_buf_is_valid(choice.bufnr) then
			if vim.fn.bufwinid(choice.bufnr) == -1 then
				vim.cmd("buffer " .. choice.bufnr)
			else
				api.nvim_set_current_win(vim.fn.bufwinid(choice.bufnr))
			end
		end
	end)
end

api.nvim_create_autocmd("TermClose", {
	callback = function(args)
		save_term_info(args.buf, nil)
	end,
})

api.nvim_create_autocmd("TabEnter", {
	callback = function()
		for bufnr, term_opts in pairs(g.nvims_terms) do
			local buf = tonumber(bufnr)
			if
				term_opts
				and term_opts.active
				and term_opts.pos ~= "float"
				and buf
				and api.nvim_buf_is_valid(buf)
				and not has_win_in_current_tab(buf)
			then
				M.display(vim.tbl_deep_extend("force", term_opts, {
					buf = buf,
					keep_focus = true,
					no_insert = true,
				}))
			end
		end
	end,
})

api.nvim_create_autocmd("WinResized", {
	callback = function()
		for bufnr, term_opts in pairs(g.nvims_terms) do
			local buf = tonumber(bufnr)
			if term_opts and term_opts.pos ~= "float" and buf and api.nvim_buf_is_valid(buf) then
				local wins = list_wins_for_buf(buf)
				local winid = wins[1]
				if winid and api.nvim_win_is_valid(winid) then
					term_opts.win_size = get_win_size_for_pos(winid, term_opts.pos)
					save_term_info(buf, term_opts)
				end
			end
		end
	end,
})

return M
