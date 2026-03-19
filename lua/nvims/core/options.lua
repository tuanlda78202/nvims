vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

opt.wrap = false

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

opt.backspace = "indent,eol,start"

opt.clipboard:append("unnamedplus")

opt.splitright = true
opt.splitbelow = true
opt.showtabline = 2

opt.swapfile = false

opt.hidden = true
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.opt_local.scrolloff = 0
		vim.opt_local.sidescrolloff = 0

		vim.fn.setenv("ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE", "fg=#a7a7a7,bg=none,bold")
	end,
})

_G.AdjustTerminalColors = function()
	vim.g.terminal_color_8 = "#b0b0b0"
	print("Terminal colors adjusted for better zsh autosuggestion visibility")
end

local original_notify = vim.notify
vim.notify = function(msg, level, opts)
	if level ~= nil and level >= vim.log.levels.ERROR then
		original_notify(msg, level, opts)
	end
end

vim.api.nvim_create_user_command("AdjustTerminalColors", function()
	_G.AdjustTerminalColors()
end, { desc = "Adjust terminal colors for better zsh autosuggestion visibility" })
