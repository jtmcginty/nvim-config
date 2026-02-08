# Neovim Configuration - Quick Start Guide

Welcome to your new Neovim setup! This guide will help you learn the features step by step.

## Installation

1. **Backup existing config (if any):**
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Create symlink:**
   ```bash
   ln -s ~/nvim-config-2026 ~/.config/nvim
   ```

3. **Launch Neovim:**
   ```bash
   nvim
   ```
   
   Lazy.nvim will automatically install all plugins. Wait for it to finish.

4. **Restart Neovim** after installation completes.

---

## Essential Keybindings

**Leader Key:** `Space`

### Navigation Basics

| Key | Action |
|-----|--------|
| `Ctrl+h/j/k/l` | Move between windows |
| `Ctrl+d` | Scroll down (auto-centers) |
| `Ctrl+u` | Scroll up (auto-centers) |
| `G` | Go to end of file (auto-centers) |

### File Explorer (Neo-tree)

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |
| `<leader>o` | Reveal current file in explorer |

**Inside Neo-tree:**
- `Enter` - Open file
- `a` - Add file/folder
- `d` - Delete
- `r` - Rename
- `c` - Copy
- `x` - Cut
- `p` - Paste
- `?` - Show help

### Fuzzy Finding (Telescope)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fr` | Find recent files |
| `<leader><leader>` | Find open buffers |
| `<leader>sg` | Search text in project (grep) |
| `<leader>sw` | Search word under cursor |
| `<leader>/` | Search in current file |
| `<leader>sh` | Search help docs |
| `<leader>sk` | Search keymaps |

**Inside Telescope:**
- `Ctrl+j/k` - Move up/down
- `Ctrl+u/d` - Scroll preview
- `Enter` - Select
- `Esc` - Close

### Harpoon (Quick File Navigation)

This is your secret weapon for focused work!

| Key | Action |
|-----|--------|
| `<leader>a` | Add current file to harpoon |
| `<leader>h` | Toggle harpoon menu |
| `<leader>1/2/3/4` | Jump to harpooned file 1/2/3/4 |

**Workflow:**
1. Open your main files (e.g., main.py, config.yaml, README.md)
2. Press `<leader>a` in each to mark them
3. Use `<leader>1`, `<leader>2`, etc. to instantly jump between them

### LSP (Code Intelligence)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Show hover documentation |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>cd` | Show diagnostic |
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |

### Git (Gitsigns)

| Key | Action |
|-----|--------|
| `]h` | Next git hunk |
| `[h` | Previous git hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gb` | Blame line |

### Lazygit (Full Git UI)

| Key | Action |
|-----|--------|
| `<leader>gg` | Open Lazygit |

**Inside Lazygit:**
- `Tab` - Switch between panels
- `Enter` - Stage/unstage/view
- `c` - Commit
- `P` - Push
- `p` - Pull
- `?` - Show help
- `q` or `Esc Esc` - Close

### Quickfix & Diagnostics

| Key | Action |
|-----|--------|
| `]q` / `[q` | Next/previous quickfix item |
| `<leader>qo` | Open quickfix list |
| `<leader>qc` | Close quickfix list |
| `<leader>xx` | Toggle diagnostics (Trouble) |
| `<leader>xd` | Buffer diagnostics (Trouble) |
| `<leader>xs` | Document symbols (Trouble) |
| `<leader>xq` | Quickfix in Trouble UI |

**Workflow:**
1. Search with `<leader>sg`, press `Ctrl+q` to send to quickfix
2. Use `]q`/`[q` to jump through results
3. Or use `<leader>xq` to view in Trouble UI

### Search & Replace (Spectre)

| Key | Action |
|-----|--------|
| `<leader>sr` | Open search/replace panel |
| `<leader>sw` | Search current word |
| `<leader>sp` | Search in current file |

**Inside Spectre:**
1. Enter search term in first field
2. Enter replacement in second field
3. Review preview of changes
4. Press `<leader>rc` to replace all
5. Press `q` to close

### Terminal

| Key | Action |
|-----|--------|
| `<leader>tt` | Toggle floating terminal |
| `Esc Esc` | Close terminal |

### Debugging (DAP)

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue/Start debugging |
| `<leader>ds` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>du` | Toggle debug UI |
| `<leader>dt` | Terminate debugging |

**Workflow:**
1. Set breakpoint with `<leader>db` (🔴 appears)
2. Start debugging with `<leader>dc`
3. Step through with `<leader>ds`
4. Inspect variables in debug UI
5. Terminate with `<leader>dt`

### Kiro AI Assistant

| Key | Action |
|-----|--------|
| `Ctrl+\` | Toggle Kiro chat |
| `Ctrl+'` | Add file/selection to context |
| `<leader>kn` | New Kiro session |
| `<leader>kr` | Restore previous session |

**Inside Kiro:**
- Type `@` to reference files
- Type `/` for slash commands
- `Shift+Tab` to switch agent modes

### Editing

| Key | Action |
|-----|--------|
| `gc` | Comment (in visual mode or with motion) |
| `gcc` | Comment current line |
| `J/K` (visual) | Move selected lines up/down |
| `ys{motion}{char}` | Surround with character |
| `cs{old}{new}` | Change surrounding |
| `ds{char}` | Delete surrounding |

---

## Learning Path

### Day 1: Basic Navigation
1. Open Neovim: `nvim`
2. Press `<leader>e` to open file explorer
3. Navigate with `j/k`, press `Enter` to open a file
4. Press `<leader>ff` to fuzzy find files
5. Type part of a filename, use `Ctrl+j/k` to navigate, `Enter` to open

### Day 2: Harpoon Workflow
1. Open 3-4 files you work with frequently
2. In each file, press `<leader>a` to mark it
3. Press `<leader>h` to see your marked files
4. Use `<leader>1`, `<leader>2`, etc. to jump between them
5. Notice how fast this is compared to switching buffers!

### Day 3: Code Intelligence
1. Open a code file
2. Hover over a function and press `K` to see documentation
3. Press `gd` to go to its definition
4. Press `gr` to see all references
5. Try `<leader>cr` to rename a variable

### Day 4: Search Everything
1. Press `<leader>sg` to search for text across your project
2. Press `<leader>sw` with cursor on a word to find all occurrences
3. Press `<leader>/` to search within current file
4. Press `<leader>sh` to search Neovim help docs

### Day 5: Kiro Integration
1. Press `Ctrl+\` to open Kiro
2. Ask it a question about your code
3. Press `Ctrl+'` to add current file to context
4. Select some code (visual mode), then `Ctrl+'` to add just that selection

### Week 2: Power User Features

**Quickfix Workflow:**
1. Search with `<leader>sg` for "TODO"
2. Press `Ctrl+q` to send results to quickfix
3. Use `]q`/`[q` to jump through each TODO
4. Or press `<leader>xq` to view in Trouble UI

**Git Workflow:**
1. Press `<leader>gg` to open Lazygit
2. Stage changes, write commit message
3. Push with `P`
4. Close with `q`

**Search & Replace:**
1. Press `<leader>sr` to open Spectre
2. Search for old variable name
3. Enter new name
4. Review changes, press `<leader>rc` to apply

**Debugging:**
1. Set breakpoint with `<leader>db`
2. Start with `<leader>dc`
3. Step through with `<leader>ds`
4. Inspect variables in UI

---

## Tips for Learning Vim Motions

Start with these essential motions:

**Movement:**
- `h/j/k/l` - Left/Down/Up/Right
- `w` - Next word
- `b` - Previous word
- `0` - Start of line
- `$` - End of line
- `gg` - Top of file
- `G` - Bottom of file

**Editing:**
- `i` - Insert before cursor
- `a` - Insert after cursor
- `o` - New line below
- `O` - New line above
- `dd` - Delete line
- `yy` - Copy line
- `p` - Paste

**Combining:**
- `d3w` - Delete 3 words
- `y$` - Copy to end of line
- `ci"` - Change inside quotes
- `di(` - Delete inside parentheses

**Pro tip:** Don't try to learn everything at once. Master one motion per day.

---

## Discovering More

- Press `Space` and wait - Which-key will show you available commands
- Press `<leader>sk` to search all keymaps
- Press `<leader>sh` to search help docs
- Type `:Telescope` and press `Tab` to see all Telescope commands
- Type `:help` followed by any topic

---

## Customization

All config files are in `~/nvim-config-2026/lua/`:

- `config/settings.lua` - Core Neovim settings
- `plugins/*.lua` - Individual plugin configurations

To add a new plugin:
1. Create a new file in `lua/plugins/`
2. Return a plugin spec (see existing files for examples)
3. Restart Neovim

To change keybindings:
1. Find the plugin file (e.g., `plugins/telescope.lua`)
2. Modify the `vim.keymap.set()` calls
3. Restart Neovim

---

## Troubleshooting

**Plugins not installing:**
- Run `:Lazy` to open plugin manager
- Press `I` to install
- Press `U` to update

**LSP not working:**
- Run `:Mason` to open LSP installer
- Press `i` on a server to install it
- Run `:LspInfo` to see active servers

**Keybinding not working:**
- Run `:Telescope keymaps` to search all keymaps
- Check if another plugin is overriding it

**Need help:**
- Press `<leader>sh` to search help
- Type `:help <topic>` for specific help
- Run `:checkhealth` to diagnose issues

---

## Advanced Navigation & Learning

### Flash - Labeled Jumps

| Key | Action |
|-----|--------|
| `s` + char | Show labels on all matches, press label to jump |
| `S` + pattern | Jump to treesitter nodes (functions, classes) |

**Example:** Press `s` then `f` - all 'f' characters get labeled. Press the label to jump instantly.

### Undotree - Undo History

| Key | Action |
|-----|--------|
| `<leader>u` | Toggle undo tree visualization |

**Inside Undotree:**
- `j/k` - Navigate history
- `Enter` - Jump to that state
- See branches where you undid and made different changes

### Database UI (Dadbod)

| Key | Action |
|-----|--------|
| `<leader>D` | Toggle database UI |

**Inside Database UI:**
- Add connections to browse databases
- Execute SQL queries
- View table schemas

### Hardtime - Learn Better Motions

Automatically enabled. Shows hints when you:
- Repeat the same motion too many times
- Use inefficient navigation patterns

Learn to use: `w/b/e` for word jumps, `f/t` for character search, `{/}` for paragraph jumps instead of holding `j/k`.

---

## Next Steps

Once comfortable with the basics:

1. **Learn more motions** - `:help motion.txt`
2. **Customize your theme** - Edit `plugins/theme.lua`
3. **Add language-specific plugins** - Create new files in `plugins/`
4. **Explore Telescope** - `:Telescope` + Tab to see all pickers
5. **Master Harpoon** - This will transform your workflow

Happy coding! 🚀
