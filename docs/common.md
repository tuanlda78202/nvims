# Common Workflow

## 1. Session Start

1. Restore project session: `<leader>wr`
2. Open file explorer: `<leader>ee`
3. Open AI sidebars in Neovim terminals:
    - Codex: `<leader>cd`
    - Claude: `<leader>cc`
4. Jump between code and terminals:
    - `<leader>wh`, `<leader>wj`, `<leader>wk`, `<leader>wl`, `<leader>we`

## 2. File and Search Flow

1. Smart files: `<leader><Space>`
2. Find all files (hidden/no-ignore): `<leader>fa`
3. Recent files: `<leader>fr` or `<leader>fo`
4. Buffers: `<leader>fb`
5. Grep project: `<leader>/` or `<leader>fs`
6. Grep word under cursor: `<leader>fc`
7. Find in current buffer: `<leader>fz`
8. Help tags: `<leader>fh`
9. Marks: `<leader>ma`

## 3. Coding and Refactor Flow (LSP)

1. Navigate:
    - `gd` definitions
    - `gD` declaration
    - `gR` references
    - `gi` implementations
    - `gt` type definitions
    - `gh` hover docs
2. Refactor:
    - `<leader>rn` rename symbol
    - `<leader>ca` code action
3. Diagnostics:
    - `<leader>D` buffer diagnostics
    - `<leader>d` line diagnostic float
    - `[d` / `]d` prev/next diagnostic
    - `<leader>rs` restart LSP

## 4. Edit Operations (Comment/Surround/Replace)

1. Comments:
    - `<leader>cl` toggle line comment (`n`, `x`)
    - `<leader>cb` toggle block comment (`n`, `x`)
2. Surround:
    - `<leader>sa` add surround (motion/selection)
    - `<leader>sA` add surround line
    - `<leader>sd` delete surround
    - `<leader>sc` / `<leader>sC` change surround
3. Replace:
    - `<leader>rr` replace with motion/selection
    - `<leader>rl` replace line
    - `<leader>re` replace to end of line

## 5. Quality + Issue Triage Flow

1. Format current file/range: `<leader>mp`
2. Trigger lint: `<leader>ll`
3. TODO navigation:
    - `[t` / `]t` previous/next todo
    - `<leader>ft` todo telescope
4. Trouble panels:
    - `<leader>xw` workspace diagnostics
    - `<leader>xd` document diagnostics
    - `<leader>xq` quickfix
    - `<leader>xl` loclist
    - `<leader>xt` todo list

## 6. Git Flow in Neovim

1. Open Git UIs:

- `<leader>gg` Snacks lazygit

1. Inspect history/status:
    - `<leader>gl` git log picker
    - `<leader>gt` git status picker
    - `<leader>cm` git commits picker

2. Hunk workflow (buffer-local via gitsigns):
    - `]h` / `[h` next/prev hunk
    - `<leader>gp` preview hunk
    - `<leader>gs` stage hunk (`n`, `v`)
    - `<leader>gr` reset hunk (`n`, `v`)
    - `<leader>gS` stage buffer
    - `<leader>gR` reset buffer
    - `<leader>gu` undo stage hunk
    - `<leader>gb` blame line
    - `<leader>gT` toggle line blame
    - `<leader>gd` / `<leader>gD` diff views
    - `ih` hunk text object (`o`, `x`)

## 7. Window/Tab/Terminal Control

1. Splits:
    - `<leader>sv`, `<leader>sh`, `<leader>se`, `<leader>sx`

2. Split resize:
    - `<leader>+`, `<leader>-` (works in normal + terminal)

3. Tabs:
    - `<leader>to`, `<leader>tx`, `<leader>tn`, `<leader>tp`, `<leader>tf`
    - `<Tab>` / `<S-Tab>` / `st` / `sT`

4. Terminal controls:
    - `<leader>h`, `<leader>v`, `<A-h>`, `<A-v>`, `<A-i>`
    - `<leader>pt` pick tracked terminal
    - Terminal escape: `<C-x>`

## 8. Neovim-Only Code Review Flow

1. Open changed files via buffers and search:
    - `<leader>fb`, `<leader>/`

2. Validate symbols and usage impact:
    - `gd`, `gR`, `gi`, `gt`

3. Scan diagnostics and todos:
    - `<leader>xw`, `<leader>xd`, `<leader>xt`
    - `[d` / `]d`, `[t` / `]t`

4. Verify style and safety:
    - `<leader>mp`, `<leader>ll`

5. Review and stage by hunk:
    - `]h`, `[h`, `<leader>gp`, `<leader>gs`

## 9. Example Flows

## A) New Feature

1. `<leader>wr` restore session
2. `<leader><Space>` open target file
3. `gd`/`gR` inspect existing flow
4. Implement + refactor: `<leader>ca`, `<leader>rn`
5. Validate: `<leader>mp`, `<leader>ll`, `<leader>xw`
6. Stage clean hunks: `<leader>gp`, `<leader>gs`

## B) Bug Fix

1. `<leader>/` search failing path
2. Jump across references: `gd`, `gR`
3. Follow diagnostics: `<leader>D`, `[d`, `]d`
4. Patch + format/lint: `<leader>mp`, `<leader>ll`
5. Re-check with trouble: `<leader>xd`

## C) Refactor

1. Locate all uses: `<leader>fs`, `gR`
2. Rename safely: `<leader>rn`
3. Review implementation/type impact: `gi`, `gt`
4. Run diagnostics + lint + format: `<leader>xw`, `<leader>ll`, `<leader>mp`
5. Stage in logical hunks only: `<leader>gp`, `<leader>gs`

## 10. End Session

1. Save current session: `<leader>ws`
2. Save file: `<C-s>`
3. Clear search highlight: `<leader>nh` (or `<Esc>`)
