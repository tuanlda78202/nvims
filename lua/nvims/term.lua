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

if cfg.base46_colors and vim.g.base46_cache and vim.uv.fs_stat(vim.g.base46_cache .. "term") then
	dofile(vim.g.base46_cache .. "term")
end

local function save_term_info(index, val)
	local terms = g.nvims_terms
	terms[tostring(index)] = val
	g.nvims_terms = terms
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
	if opts.pos == "float" then
		create_float(opts.buf, opts.float_opts)
	else
		vim.cmd(opts.pos)
	end

	local win = api.nvim_get_current_win()
	opts.win = win

	vim.bo[opts.buf].buflisted = false
	vim.bo[opts.buf].ft = "NvimsTerm_" .. opts.pos:gsub(" ", "")

	if cfg.startinsert then
		vim.cmd("startinsert")
	end

	if opts.pos ~= "float" then
		local pos_type = pos_data[opts.pos]
		local size = opts.size or cfg.sizes[opts.pos]
		local new_size = vim.o[pos_type.area] * size
		api["nvim_win_set_" .. pos_type.resize](0, math.floor(new_size))
	end

	api.nvim_win_set_buf(win, opts.buf)
	local winopts = vim.tbl_deep_extend("force", cfg.winopts, opts.winopts or {})
	for k, v in pairs(winopts) do
		vim.wo[win][k] = v
	end

	save_term_info(opts.buf, opts)
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
	local winid = buf_valid and vim.fn.bufwinid(existing_buf) or -1

	opts.buf = buf_valid and existing_buf or nil
	if (not existing) or not buf_valid or winid == -1 then
		create(opts)
	else
		api.nvim_win_close(winid, true)
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

return M
