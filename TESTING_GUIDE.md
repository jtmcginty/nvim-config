# Testing Your New Neovim Setup

Follow these exercises to test each feature and build muscle memory.

## Setup Check

1. **Install the config:**
   ```bash
   ln -s ~/nvim-config-2026 ~/.config/nvim
   nvim
   ```

2. **Wait for plugins to install** (watch the bottom of the screen)

3. **Restart Neovim** after installation completes

4. **Run health check:**
   ```
   :checkhealth
   ```
   Look for any errors (some warnings are okay)

---

## Exercise 1: File Explorer (5 minutes)

**Goal:** Learn to navigate files with Neo-tree

1. Open Neovim in your DLP project:
   ```bash
   cd ~/dev/llm-dlp-proxy
   nvim
   ```

2. Press `Space` then `e` to open file explorer

3. Navigate with `j` (down) and `k` (up)

4. Press `Enter` on a file to open it

5. Press `Space` then `e` again to close explorer

6. Press `Space` then `o` to reveal current file in explorer

**Success:** You can open and navigate the file tree

---

## Exercise 2: Fuzzy Finding (10 minutes)

**Goal:** Master Telescope for finding files and text

### Find Files

1. Press `Space` `f` `f` (find files)

2. Type part of a filename (e.g., "addon")

3. Use `Ctrl+j` and `Ctrl+k` to move through results

4. Press `Enter` to open

5. Press `Esc` to cancel

### Search Text

1. Press `Space` `s` `g` (search grep)

2. Type a word that appears in your code (e.g., "proxy")

3. Navigate results with `Ctrl+j/k`

4. Press `Enter` to jump to that line

### Search in Current File

1. Open a large file

2. Press `Space` `/`

3. Type a word to find in this file

4. See results instantly

**Success:** You can find any file or text in seconds

---

## Exercise 3: Harpoon Workflow (10 minutes)

**Goal:** Set up quick navigation between key files

1. Open your main project file (e.g., `src/proxy/addon.py`)

2. Press `Space` `a` to add it to harpoon
   - You should see a notification

3. Open another important file (e.g., `config/policy.yaml`)

4. Press `Space` `a` to add it

5. Open a third file and add it

6. Press `Space` `h` to see your harpoon menu

7. Press `Space` `1` to jump to first file

8. Press `Space` `2` to jump to second file

9. Press `Space` `3` to jump to third file

**Success:** You can instantly jump between your key files

**Pro tip:** This is the feature that will change your workflow the most!

---

## Exercise 4: LSP Features (15 minutes)

**Goal:** Use code intelligence features

### Go to Definition

1. Open a Python file with function calls

2. Put cursor on a function name

3. Press `g` `d` (go to definition)

4. Press `Ctrl+o` to jump back

### See References

1. Put cursor on a function or variable

2. Press `g` `r` (go to references)

3. Telescope shows all uses

4. Navigate and press `Enter` to jump

### Hover Documentation

1. Put cursor on a function

2. Press `K` (capital K)

3. See documentation popup

4. Press `K` again to jump into it

5. Press `q` to close

### Rename Symbol

1. Put cursor on a variable name

2. Press `Space` `c` `r` (code rename)

3. Type new name

4. Press `Enter`

5. All references are renamed!

**Success:** You can navigate code like an IDE

---

## Exercise 5: Git Integration (10 minutes)

**Goal:** See and manage git changes

1. Make a change to a file (add a comment)

2. Save the file (`:w`)

3. Look at the left gutter - you should see a `~` or `+`

4. Press `]h` to jump to next change

5. Press `[h` to jump to previous change

6. Press `Space` `g` `p` to preview the change

7. Press `Space` `g` `s` to stage the hunk

8. Press `Space` `g` `r` to reset the hunk (undo)

9. Press `Space` `g` `b` to see git blame

**Success:** You can see and manage git changes without leaving Neovim

---

## Exercise 6: Kiro AI Assistant (10 minutes)

**Goal:** Use Kiro directly in Neovim

1. Open a code file

2. Press `Ctrl+\` to open Kiro chat

3. Ask a question: "What does this file do?"

4. Wait for response

5. Select some code (visual mode with `v` and arrow keys)

6. Press `Ctrl+'` to add selection to context

7. Ask Kiro to explain the selected code

8. Press `Ctrl+\` to close chat

9. Press `Ctrl+\` again to reopen (session persists)

**Success:** You can chat with Kiro without leaving your editor

---

## Exercise 7: Editing Shortcuts (10 minutes)

**Goal:** Learn efficient editing

### Comment Code

1. Select multiple lines (visual mode: `V` then `j/k`)

2. Press `g` `c` to toggle comments

3. Press `g` `c` `c` in normal mode to comment current line

### Move Lines

1. Select lines (visual mode: `V` then `j/k`)

2. Press `J` to move down

3. Press `K` to move up

### Surround Text

1. Put cursor on a word

2. Press `y` `s` `i` `w` `"` (surround inner word with quotes)

3. Press `c` `s` `"` `'` (change surrounding quotes to single quotes)

4. Press `d` `s` `'` (delete surrounding quotes)

**Success:** You can edit code efficiently

---

## Exercise 8: Window Management (5 minutes)

**Goal:** Work with multiple files side-by-side

1. Open a file

2. Type `:vsplit` to split vertically

3. Press `Space` `f` `f` to find another file

4. Press `Ctrl+h` to move to left window

5. Press `Ctrl+l` to move to right window

6. Press `Ctrl+q` to close current window

**Success:** You can work with multiple files at once

---

## Exercise 9: Discovering Features (5 minutes)

**Goal:** Learn to find features yourself

1. Press `Space` and wait 1 second

2. Which-key shows available commands

3. Press `s` to see search commands

4. Press `Esc` to cancel

5. Press `Space` `s` `k` to search all keymaps

6. Type "git" to find git-related commands

7. Press `Space` `s` `h` to search help docs

8. Type "telescope" to learn about telescope

**Success:** You can discover features on your own

---

## Daily Workflow Suggestion

Once you're comfortable, try this workflow:

### Morning Setup (30 seconds)
1. `cd` to your project
2. `nvim`
3. `Space` `f` `f` to find your main file
4. `Space` `a` to harpoon it
5. Repeat for 3-4 key files
6. Now use `Space` `1/2/3/4` to jump between them all day

### During Work
- `Space` `f` `f` - Find files
- `Space` `s` `g` - Search for text
- `g` `d` - Jump to definitions
- `Ctrl+\` - Ask Kiro for help
- `Space` `g` `p` - Preview git changes

### End of Day
- `Space` `g` `s` - Stage changes
- Exit Neovim
- Commit from terminal

---

## Troubleshooting

**Keybinding doesn't work:**
- Press `Space` `s` `k` to search all keymaps
- Make sure you're in normal mode (press `Esc`)

**LSP not working:**
- Run `:Mason` and install language servers
- Run `:LspInfo` to see status

**Telescope not finding files:**
- Make sure you're in a project directory
- Check that `ripgrep` is installed: `brew install ripgrep`

**Kiro not connecting:**
- Make sure `kiro-cli acp` works from terminal
- Check `:messages` for errors

---

## Next Steps

After completing these exercises:

1. **Practice daily** - Use Neovim for all your coding
2. **Learn one new motion per day** - `:help motion.txt`
3. **Customize** - Edit config files to make it yours
4. **Explore plugins** - Check out the plugin docs

You're now ready to be a Neovim power user! 🚀
