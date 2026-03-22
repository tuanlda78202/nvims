# Neovim Key Mapping Customization Documentation

> [!caution]
> This document is deprecated and may not reflect the current state of the configuration

## Table of Contents

- [Overview](#overview)
- [Configuration Structure](#configuration-structure)
- [Leader Key Configuration](#leader-key-configuration)
- [Core Key Mappings](#core-key-mappings)
- [Plugin-Specific Key Mappings](#plugin-specific-key-mappings)
- [Understanding Neovim Key Mapping](#understanding-neovim-key-mapping)
- [Customization Guidelines](#customization-guidelines)

## Overview

My Neovim configuration uses a modern Lua-based approach with the Lazy.nvim plugin manager. Key mappings are defined using `vim.keymap.set()` and are distributed across core configuration files and individual plugin configurations.

## Configuration Structure

```lua
-- init.lua
require("nvims.core")
require("nvims.lazy")
```

My configuration loads:

1. **Core configuration** (`nvims.core`) - Contains basic options and keymaps
2. **Plugin manager** (`nvims.lazy`) - Manages plugin installations and configurations

```lua
-- lua/nvims/core/init.lua
require("nvims.core.options")
require("nvims.core.keymaps")
```

## Leader Key Configuration

```lua
-- lua/nvims/core/keymaps.lua
vim.g.mapleader = " "
```

My leader key is set to **Space** (`" "`), which is a popular choice for modern Neovim configurations.

## Core Key Mappings

### General Navigation and Editing

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `jk` | Insert | `<ESC>` | Exit insert mode (alternative to Esc) |
| `J` | Normal | `5j` | Move down 5 lines quickly |
| `K` | Normal | `5k` | Move up 5 lines quickly |

### Search and Utility

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `<Space>nh` | Normal | `:nohl<CR>` | Clear search highlights |
| `<Space>+` | Normal | `<C-a>` | Increment number under cursor |
| `<Space>-` | Normal | `<C-x>` | Decrement number under cursor |

### Window Management

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `<Space>sv` | Normal | `<C-w>v` | Split window vertically |
| `<Space>sh` | Normal | `<C-w>s` | Split window horizontally |
| `<Space>se` | Normal | `<C-w>=` | Make splits equal size |
| `<Space>sx` | Normal | `:close<CR>` | Close current split |
| `<Space>sm` | Normal | `:MaximizerToggle<CR>` | Maximize/minimize split |

### Tab Management

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `<Space>to` | Normal | `:tabnew<CR>` | Open new tab |
| `<Space>tx` | Normal | `:tabclose<CR>` | Close current tab |
| `<Space>tn` | Normal | `:tabn<CR>` | Go to next tab |
| `<Space>tp` | Normal | `:tabp<CR>` | Go to previous tab |
| `<Space>tf` | Normal | `:tabnew %<CR>` | Open current buffer in new tab |

## Plugin-Specific Key Mappings

### File Explorer (nvim-tree)

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `<Space>ef` | Normal | `:NvimTreeFocus<CR>` | Focus file explorer |
| `<Space>ee` | Normal | `:NvimTreeToggle<CR>` | Toggle file explorer |
| `<Space>et` | Normal | `:NvimTreeFindFileToggle<CR>` | Toggle file explorer on current file |
| `<Space>ec` | Normal | `:NvimTreeCollapse<CR>` | Collapse file explorer |
| `<Space>er` | Normal | `:NvimTreeRefresh<CR>` | Refresh file explorer |

### Telescope (Fuzzy Finder)

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `<Space>ff` | Normal | `:Telescope find_files<cr>` | Fuzzy find files in cwd |
| `<Space>fr` | Normal | `:Telescope oldfiles<cr>` | Fuzzy find recent files |
| `<Space>fs` | Normal | `:Telescope live_grep<cr>` | Find string in cwd (live grep) |
| `<Space>fc` | Normal | `:Telescope grep_string<cr>` | Find string under cursor in cwd |
| `<Space>ft` | Normal | `:TodoTelescope<cr>` | Find todos |

#### Telescope Internal Mappings (Insert Mode)

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `<Ctrl-k>` | Insert | `move_selection_previous` | Move to previous result |
| `<Ctrl-j>` | Insert | `move_selection_next` | Move to next result |
| `<Ctrl-q>` | Insert | `send_to_qflist` | Send selected to quickfix list |

### GitHub Copilot (AI Code Completion)

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `<Tab>` | Insert | `accept()` | Accept Copilot suggestion |
| `<Alt-]>` | Insert | `next()` | Next Copilot suggestion |
| `<Alt-[>` | Insert | `prev()` | Previous Copilot suggestion |
| `<Ctrl-]>` | Insert | `dismiss()` | Dismiss Copilot suggestion |
| `<Alt-CR>` | Normal | `open_panel()` | Open Copilot panel |

#### Copilot Panel Mappings

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `[[` | Normal | `jump_prev` | Jump to previous suggestion |
| `]]` | Normal | `jump_next` | Jump to next suggestion |
| `<CR>` | Normal | `accept` | Accept selected suggestion |
| `gr` | Normal | `refresh` | Refresh suggestions |

### Code Completion (nvim-cmp)

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `<Ctrl-n>` | Insert | `select_next_item()` | Next completion item |
| `<Ctrl-p>` | Insert | `select_prev_item()` | Previous completion item |
| `<Ctrl-k>` | Insert | `select_prev_item()` | Alternative: Previous completion item |
| `<Ctrl-j>` | Insert | `select_next_item()` | Alternative: Next completion item |
| `<Ctrl-Space>` | Insert | `complete()` | Trigger completion menu |
| `<Ctrl-e>` | Insert | `abort()` | Close completion menu |
| `<CR>` | Insert | `confirm()` | Confirm selected completion |
| `<Ctrl-b>` | Insert | `scroll_docs(-4)` | Scroll documentation up |
| `<Ctrl-f>` | Insert | `scroll_docs(4)` | Scroll documentation down |

#### File and Search Operations

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `<Space><Space>` | Normal | `Snacks.picker.smart()` | Smart Find Files (intelligent file picker) |
| `<Space>/` | Normal | `Snacks.picker.grep()` | Live grep search |
| `<Space>:` | Normal | `Snacks.picker.command_history()` | Command history picker |
| `<Space>n` | Normal | `Snacks.picker.notifications()` | Notification history |

#### Git Operations

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `<Space>gl` | Normal | `Snacks.picker.git_log()` | Git log picker |
| `<Space>gB` | Normal/Visual | `Snacks.gitbrowse()` | Browse git repository online |
| `<Space>gg` | Normal | `Snacks.lazygit()` | Open Lazygit |

#### Terminal Operations

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `<Ctrl-`>` | Normal | `Snacks.terminal()` | Toggle terminal |
| `<Ctrl-_>` | Normal | `Snacks.terminal()` | Toggle terminal (alternative) |

#### UI and Utilities

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `<Space>Nc` | Normal | `Snacks.win()` | Open `docs/common.md` workflow notes |
| `<Space>Nv` | Normal | `Snacks.win()` | Open `docs/vim.md` cheatsheet |

#### Toggle Features

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `<Space>ud` | Normal | `Snacks.toggle.diagnostics()` | Toggle diagnostics display |
| `<Space>uc` | Normal | `Snacks.toggle.conceallevel()` | Toggle conceallevel |
| `<Space>uT` | Normal | `Snacks.toggle.treesitter()` | Toggle treesitter |
| `<Space>ub` | Normal | `Snacks.toggle.background()` | Toggle dark/light background |
| `<Space>uh` | Normal | `Snacks.toggle.inlay_hints()` | Toggle LSP inlay hints |

### LSP (Language Server Protocol)

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `gR` | Normal | `:Telescope lsp_references<CR>` | Show LSP references |
| `gD` | Normal | `vim.lsp.buf.declaration` | Go to declaration |
| `gd` | Normal | `:Telescope lsp_definitions<CR>` | Show LSP definitions |
| `gi` | Normal | `:Telescope lsp_implementations<CR>` | Show LSP implementations |
| `gt` | Normal | `:Telescope lsp_type_definitions<CR>` | Show LSP type definitions |
| `<Space>ca` | Normal/Visual | `vim.lsp.buf.code_action` | See available code actions |
| `<Space>rn` | Normal | `vim.lsp.buf.rename` | Smart rename |
| `<Space>D` | Normal | `:Telescope diagnostics bufnr=0<CR>` | Show buffer diagnostics |
| `<Space>d` | Normal | `vim.diagnostic.open_float` | Show line diagnostics |
| `[d` | Normal | `vim.diagnostic.goto_prev` | Go to previous diagnostic |
| `]d` | Normal | `vim.diagnostic.goto_next` | Go to next diagnostic |
| `gh` | Normal | `vim.lsp.buf.hover` | Show documentation for item under cursor |
| `<Space>rs` | Normal | `:LspRestart<CR>` | Restart LSP |

### Git Integration (gitsigns)

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `]h` | Normal | `next_hunk` | Next git hunk |
| `[h` | Normal | `prev_hunk` | Previous git hunk |
| `<Space>hs` | Normal/Visual | `stage_hunk` | Stage hunk |
| `<Space>hr` | Normal/Visual | `reset_hunk` | Reset hunk |
| `<Space>hS` | Normal | `stage_buffer` | Stage entire buffer |
| `<Space>hR` | Normal | `reset_buffer` | Reset entire buffer |
| `<Space>hu` | Normal | `undo_stage_hunk` | Undo stage hunk |
| `<Space>hp` | Normal | `preview_hunk` | Preview hunk |
| `<Space>hb` | Normal | `blame_line` | Blame line (full) |
| `<Space>hB` | Normal | `toggle_current_line_blame` | Toggle line blame |
| `<Space>hd` | Normal | `diffthis` | Diff this |
| `<Space>hD` | Normal | `diffthis("~")` | Diff this ~ |
| `ih` | Operator/Visual | `select_hunk` | Select hunk text object |

### Terminal Integration

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `<Ctrl-`>` | Normal/Insert | `Snacks.terminal()` | Toggle terminal (Snacks) |
| `<Esc>` | Terminal | `:ToggleTerm<CR>` | Exit and toggle terminal |

### Substitute Operations

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `s` | Normal | `substitute.operator` | Substitute with motion |
| `ss` | Normal | `substitute.line` | Substitute line |
| `S` | Normal | `substitute.eol` | Substitute to end of line |
| `s` | Visual | `substitute.visual` | Substitute in visual mode |

### Session Management

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `<Space>wr` | Normal | `:SessionRestore<CR>` | Restore session for cwd |
| `<Space>ws` | Normal | `:SessionSave<CR>` | Save session for cwd |

### Code Outline

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `<Space>o` | Normal | `:Outline<CR>` | Toggle outline/symbol view |

### Todo Comments Navigation

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `]t` | Normal | `jump_next()` | Next todo comment |
| `[t` | Normal | `jump_prev()` | Previous todo comment |

### Code Quality

| Key Combination | Mode | Action | Description |
|---|---|---|---|
| `<Space>l` | Normal | `lint.try_lint()` | Trigger linting for current file |
| `<Space>mp` | Normal/Visual | `conform.format()` | Format file or range |

## Understanding Neovim Key Mapping

### Basic Syntax

```lua
vim.keymap.set(mode, lhs, rhs, opts)
```

**Parameters:**

- `mode`: String or table of strings specifying vim modes
  - `"n"` = Normal mode
  - `"i"` = Insert mode
  - `"v"` = Visual mode
  - `"x"` = Visual block mode
  - `"t"` = Terminal mode
  - `"o"` = Operator-pending mode
- `lhs`: Left-hand side (the key combination to map)
- `rhs`: Right-hand side (the action to perform)
- `opts`: Table of options (optional)

### Common Options

```lua
{
  desc = "Description",    -- Description for which-key and help
  silent = true,           -- Don't show command in command line
  noremap = true,          -- Don't allow recursive mapping
  buffer = bufnr,          -- Buffer-specific mapping
  expr = true,             -- Expression mapping
}
```

### Mode Specifications

- `"n"` - Normal mode only
- `"i"` - Insert mode only
- `{ "n", "v" }` - Both normal and visual modes
- `{ "n", "i" }` - Both normal and insert modes
- `{ "o", "x" }` - Operator-pending and visual block modes

### Key Discovery with which-key

My configuration includes **which-key.nvim** which provides a popup showing available key mappings when you press a prefix key like `<Space>`. This helps with key discovery and learning my mappings.

```lua
-- lua/nvims/plugins/which-key.lua
init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
end,
```

The timeout is set to 500ms, so which-key will show after half a second of inactivity.

## Customization Guidelines

### Adding New Mappings

1. **Core mappings**: Add to `lua/nvims/core/keymaps.lua` for general editor mappings
2. **Plugin-specific mappings**: Add within the plugin's configuration file in `lua/nvims/plugins/`

### Best Practices

1. **Use descriptive descriptions**: Always include a `desc` option for better documentation
2. **Group related mappings**: Use consistent prefixes (e.g., `<leader>f` for find operations)
3. **Avoid conflicts**: Check existing mappings before adding new ones
4. **Use leader key**: Leverage `<Space>` as leader for custom mappings
5. **Buffer-specific mappings**: Use buffer-local mappings for LSP and other contextual features

### Example of Adding Custom Mapping

```lua
-- In lua/nvims/core/keymaps.lua
keymap.set("n", "<leader>xx", "<cmd>MyCustomCommand<CR>", { desc = "My custom action" })

-- In a plugin configuration
vim.keymap.set("n", "<leader>pp", function()
  -- Custom function
end, { desc = "Plugin specific action" })
```

### Key Mapping Categories by Prefix

| Prefix | Category | Examples |
|---|---|---|
| `<Space>f` | File/Find operations | `ff`, `fr`, `fs`, `fc`, `ft` |
| `<Space>e` | Explorer operations | `ee`, `ef`, `et`, `ec`, `er` |
| `<Space>g` | Git operations | `gl`, `gB`, `gg`, `hs`, `hr`, `hp`, `hb`, `hd` |
| `<Space>h` | Git/Hunk operations | `hs`, `hr`, `hp`, `hb`, `hd` |
| `<Space>s` | Split/Window operations | `sv`, `sh`, `se`, `sx`, `sm` |
| `<Space>t` | Tab/Todo operations | `to`, `tx`, `tn`, `tp`, `tf` |
| `<Space>u` | Toggle/UI operations | `ud`, `uc`, `uT`, `ub`, `uh` |
| `<Space>w` | Workspace/Session | `wr`, `ws` |
| `g` | Go to operations | `gd`, `gD`, `gi`, `gt`, `gR`, `gh` |
| `[` / `]` | Navigation | `[d`, `]d`, `[h`, `]h`, `[t`, `]t` |

### Plugin Manager Configuration

My configuration uses Lazy.nvim for plugin management:

```lua
-- lua/nvims/lazy.lua
require("lazy").setup({
  { import = "nvims.plugins" },
  { import = "nvims.plugins.lsp" }
}, {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
```

This setup automatically loads all plugin configurations from the `lua/nvims/plugins/` directory, making it easy to organize and manage plugin-specific keymaps.

### Quick Reference Summary

#### Most Used Key Patterns

- `<Space>` + letter = Main actions (find, explore, etc.)
- `g` + letter = Go to operations (LSP navigation)
- `[` / `]` + letter = Previous/Next navigation
- `<Ctrl>` + key = Special functions (terminal toggle, etc.)

#### Essential Daily Usage Keys

- `<Space><Space>` - Smart Find Files
- `<Space>ff` - Find files (Telescope)
- `<Space>ee` - Toggle file explorer
- `<Space>/` - Live grep
- `<Space>fs` - Search in files (Telescope)
- `<Tab>` - Accept Copilot suggestion (Insert mode)
- `<Ctrl-n>/<Ctrl-p>` - Navigate completions
- `gd` - Go to definition
- `<Space>ca` - Code actions
- `<Space>nh` - Clear highlights
- `jk` - Exit insert mode
- `<Space>gl` - Git log picker
- `<Space>gg` - Lazygit
- `<Space>n` - Notification history
- `<Space>:` - Command history
- `<Space>ud` - Toggle diagnostics
- `<Space>ub` - Toggle background
- `<Ctrl-`>` - Toggle terminal
