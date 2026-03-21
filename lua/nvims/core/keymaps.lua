vim.g.mapleader = " "

local keymap = vim.keymap
local term = require("nvims.term")
local api = vim.api

local function is_editable_window(win)
	local buf = api.nvim_win_get_buf(win)
	local bt = vim.bo[buf].buftype
	return bt == "" and vim.bo[buf].modifiable
end

local function focus_editable_window(dir)
	local current = api.nvim_get_current_win()
	local wins = api.nvim_tabpage_list_wins(0)

	vim.cmd("wincmd " .. dir)
	if is_editable_window(api.nvim_get_current_win()) then
		return
	end

	for _ = 1, #wins - 1 do
		vim.cmd("wincmd " .. dir)
		if is_editable_window(api.nvim_get_current_win()) then
			return
		end
	end

	api.nvim_set_current_win(current)
end

local function focus_any_editable_window()
	for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
		if is_editable_window(win) then
			api.nvim_set_current_win(win)
			return
		end
	end
	vim.notify("No editable file window found", vim.log.levels.WARN)
end

local function term_focus_editable_window(dir)
	vim.cmd("stopinsert")
	focus_editable_window(dir)
end

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("i", "<C-b>", "<ESC>^i", { desc = "Move beginning of line" })
keymap.set("i", "<C-e>", "<End>", { desc = "Move end of line" })
keymap.set("i", "<C-h>", "<Left>", { desc = "Move left" })
keymap.set("i", "<C-l>", "<Right>", { desc = "Move right" })
keymap.set("i", "<C-j>", "<Down>", { desc = "Move down" })
keymap.set("i", "<C-k>", "<Up>", { desc = "Move up" })

keymap.set("n", "J", "5j", { desc = "Move down 5 lines" })
keymap.set("n", "K", "5k", { desc = "Move up 5 lines" })
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Switch window left" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Switch window right" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Switch window down" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Switch window up" })
keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Switch window left" })
keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Switch window right" })
keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Switch window down" })
keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Switch window up" })
keymap.set("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })
keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
keymap.set("n", "<C-c>", "<cmd>%y+<CR>", { desc = "Copy whole file" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<leader>u", "<C-o>", { desc = "Jump back" })
keymap.set("n", "<leader>ch", function()
	require("nvims.cheatsheet").toggle()
end, { desc = "Open keymap cheatsheet" })
keymap.set("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "WhichKey all keymaps" })
keymap.set("n", "<leader>wq", function()
	vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
end, { desc = "WhichKey query lookup" })
keymap.set("n", "<leader>mi", "<cmd>MasonInstallAll<CR>", { desc = "Mason install all tools" })

keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

keymap.set("n", "<leader>wh", function()
	focus_editable_window("h")
end, { desc = "Move to left editable window" })
keymap.set("n", "<leader>wj", function()
	focus_editable_window("j")
end, { desc = "Move to bottom editable window" })
keymap.set("n", "<leader>wk", function()
	focus_editable_window("k")
end, { desc = "Move to top editable window" })
keymap.set("n", "<leader>wl", function()
	focus_editable_window("l")
end, { desc = "Move to right editable window" })
keymap.set("t", "<leader>wh", function()
	term_focus_editable_window("h")
end, { desc = "Move to left editable window" })
keymap.set("t", "<leader>wj", function()
	term_focus_editable_window("j")
end, { desc = "Move to bottom editable window" })
keymap.set("t", "<leader>wk", function()
	term_focus_editable_window("k")
end, { desc = "Move to top editable window" })
keymap.set("t", "<leader>wl", function()
	term_focus_editable_window("l")
end, { desc = "Move to right editable window" })
keymap.set({ "n", "t" }, "<leader>we", function()
	if vim.bo.buftype == "terminal" then
		vim.cmd("stopinsert")
	end
	focus_any_editable_window()
end, { desc = "Jump to any editable file window" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
keymap.set("n", "<Tab>", "<cmd>tabnext<CR>", { desc = "Go to next tab" })
keymap.set("n", "<S-Tab>", "<cmd>tabprevious<CR>", { desc = "Go to previous tab" })
keymap.set("n", "st", "<cmd>tabnext<CR>", { desc = "Go to next tab" })
keymap.set("n", "sT", "<cmd>tabprevious<CR>", { desc = "Go to previous tab" })

keymap.set("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal escape mode" })
keymap.set({ "n", "t" }, "<leader>h", function()
	term.toggle({ pos = "sp", id = "hTerm" })
end, { desc = "Terminal toggle horizontal term" })
keymap.set({ "n", "t" }, "<leader>v", function()
	term.toggle({ pos = "vsp", id = "vTerm" })
end, { desc = "Terminal toggle vertical term" })
keymap.set({ "n", "t" }, "<A-v>", function()
	term.toggle({ pos = "vsp", id = "vtoggleTerm" })
end, { desc = "Terminal toggle vertical term" })
keymap.set({ "n", "t" }, "<A-h>", function()
	term.toggle({ pos = "sp", id = "htoggleTerm" })
end, { desc = "Terminal toggle horizontal term" })
keymap.set({ "n", "t" }, "<A-i>", function()
	term.toggle({ pos = "float", id = "floatTerm" })
end, { desc = "Terminal toggle floating term" })
keymap.set({ "n", "t" }, "<leader>cd", function()
	term.toggle({ pos = "vsp", id = "codexTerm", cmd = "codex" })
end, { desc = "Terminal toggle Codex sidebar" })
keymap.set({ "n", "t" }, "<leader>cc", function()
	term.toggle({ pos = "vsp", id = "claudeTerm", cmd = "claude" })
end, { desc = "Terminal toggle Claude sidebar" })
keymap.set("n", "<leader>pt", function()
	term.pick()
end, { desc = "Pick tracked terminal" })
