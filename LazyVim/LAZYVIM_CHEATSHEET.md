# LazyVim Essential Cheatsheet

> **Leader key** = `<Space>` (referred to as `<leader>` below)

---

## 1. File Navigation

### Finding Files (Telescope)

| Keybinding | Description |
|---|---|
| `<leader>ff` | Find files (from project root) |
| `<leader>fF` | Find files (from current working directory) |
| `<leader>fr` | Recent/old files |
| `<leader>fR` | Recent files (cwd) |
| `<leader><space>` | Find files (same as `<leader>ff`) |

### File Browser (Neo-tree)

| Keybinding | Description |
|---|---|
| `<leader>e` | Toggle file explorer (focus on current file) |
| `<leader>E` | Toggle file explorer (cwd) |
| `<leader>fe` | Toggle file explorer (focus on current file, same as `<leader>e`) |
| `<leader>fE` | Toggle file explorer (cwd, same as `<leader>E`) |

**Inside Neo-tree:**

| Key | Description |
|---|---|
| `<CR>` or `l` | Open file / expand folder |
| `h` | Collapse folder / go to parent |
| `a` | Add (create) a new file or directory (end name with `/` for directory) |
| `d` | Delete file/directory |
| `r` | Rename file/directory |
| `c` | Copy file |
| `m` | Move file |
| `y` | Copy file path |
| `Y` | Copy relative file path |
| `p` | Paste from clipboard |
| `P` | Preview file |
| `.` | Set as root directory |
| `H` | Toggle hidden files |
| `/` | Fuzzy finder within tree |
| `q` | Close Neo-tree |

---

## 2. Buffer Navigation

| Keybinding | Description |
|---|---|
| `<S-h>` (`Shift+h`) | Previous buffer |
| `<S-l>` (`Shift+l`) | Next buffer |
| `<leader>bb` | Switch buffer (fuzzy search open buffers) |
| `<leader>bd` | Delete current buffer |
| `<leader>bD` | Delete current buffer and window |
| `<leader>bo` | Delete other buffers (keep only current) |
| `<leader>,` | Switch buffer (same as `<leader>bb`) |
| `[b` | Previous buffer |
| `]b` | Next buffer |
| `<leader>bp` | Toggle pin buffer |

---

## 3. Project / Root Directory Navigation

LazyVim auto-detects the project root using LSP workspace folders, or patterns like `.git`, `lua/`, `Makefile`, `package.json`, etc.

| Keybinding | Description |
|---|---|
| `<leader>fp` | Find files in Neovim data/plugin directory |

### Project Switcher (Enabled)

The **project extra** (`lazyvim.plugins.extras.util.project`) is enabled in your config. It uses [project.nvim](https://github.com/ahmedkhalf/project.nvim) to track and switch between projects.

| Keybinding | Description |
|---|---|
| `<leader>fp` | Open project list -- fuzzy search and switch to any project |

### How Projects Get Added to the List

Projects are added **automatically**. When you open a file in a directory that contains any of these markers, it gets registered as a project:

- `.git` directory
- `Makefile`
- `package.json`
- `_darcs/`
- `.hg/`
- `.bzr/`
- `.svn/`
- Or any directory with an active LSP root

So the workflow is simple:
1. Open Neovim in a new project directory (e.g., `nvim ~/code/my-app/`)
2. Open any file in that project
3. The project is now saved -- it will appear in `<leader>fp` from now on

### Adding a Project Manually

If a project doesn't get auto-detected (e.g., no `.git` or `package.json`), you can:

1. **Initialize a git repo** (easiest way):
   ```sh
   cd ~/path/to/project && git init
   ```
   Then open any file in Neovim -- the project will be registered.

2. **Change directory inside Neovim** and open a file:
   ```vim
   :cd ~/path/to/project
   :e .
   ```

3. **Add custom detection patterns** in your plugin config (`lua/plugins/project.lua`):
   ```lua
   return {
     {
       "ahmedkhalf/project.nvim",
       opts = {
         -- Add custom patterns for project detection
         patterns = { ".git", "Makefile", "package.json", "Cargo.toml", "go.mod", ".project-root" },
         -- You can use manual_mode = false (default) for auto-detection
         -- Or set manual_mode = true to only register via :ProjectRoot
       },
     },
   }
   ```
   With a custom pattern like `".project-root"`, you can just `touch .project-root` in any folder to make it a recognized project.

### Managing the Project List

| Command | Description |
|---|---|
| `<leader>fp` | Browse and switch projects |
| `:Telescope projects` | Same as above |

Inside the project picker:
- Type to fuzzy-filter the list
- `<CR>` to switch to the selected project (changes cwd and opens Neo-tree/files)
- `<C-d>` to delete/remove a project from the list

The project history is stored in:
```
~/.local/share/nvim/project_nvim/project_history
```
You can also edit this file directly to add or remove entries (one path per line).

Alternatively, you can use Telescope to navigate to any directory:
- `<leader>ff` then type the path
- `:cd /path/to/project` to change the working directory manually

---

## 4. Search & Grep (Finding Text Across Files)

| Keybinding | Description |
|---|---|
| `<leader>sg` | Grep (search text across all files in project) |
| `<leader>sG` | Grep (cwd) |
| `<leader>sw` | Search current word across project |
| `<leader>sW` | Search current word (cwd) |
| `<leader>/` | Grep (same as `<leader>sg`) |
| `<leader>sb` | Search in current buffer (fuzzy) |
| `<leader>ss` | Goto symbol (in current file, via LSP) |
| `<leader>sS` | Goto symbol (in workspace, via LSP) |

---

## 5. Terminal

| Keybinding | Description |
|---|---|
| `` <C-/> `` (`Ctrl+/`) | Toggle floating terminal |
| `` <C-_> `` (`Ctrl+_`) | Toggle floating terminal (alternate binding) |
| `<leader>ft` | Open floating terminal (from project root) |
| `<leader>fT` | Open floating terminal (from cwd) |

**Inside the terminal:**

| Key | Description |
|---|---|
| `` <C-/> `` | Toggle (hide) the terminal |
| `<Esc><Esc>` | Enter normal mode inside terminal |
| `<C-h/j/k/l>` | Navigate to other windows from terminal |

**Tip:** You can open multiple terminal instances. LazyVim uses `Snacks.terminal` (or `toggleterm` if configured). Each `` <C-/> `` press toggles the same terminal. To get a **new** terminal, use:
```
:lua Snacks.terminal()
```

### Terminal in a Split

You can also open terminals in splits using native Neovim:
```vim
:split | terminal     " horizontal split terminal
:vsplit | terminal    " vertical split terminal
```

---

## 6. Bookmarks & Marks (Jumping to Saved Locations)

### Vim Built-in Marks

Vim has a powerful marks system built in. Marks let you "bookmark" a line and jump back to it.

**Setting a mark:**

| Command | Description |
|---|---|
| `m{a-z}` | Set a **local** mark (per-buffer). e.g., `ma` sets mark "a" |
| `m{A-Z}` | Set a **global** mark (across files). e.g., `mA` sets mark "A" |

**Jumping to a mark:**

| Command | Description |
|---|---|
| `` `{mark} `` | Jump to the exact line and column of the mark |
| `'{mark}` | Jump to the beginning of the marked line |
| `` `0 `` | Jump to position where you last exited Neovim |
| `` `. `` | Jump to position of last change in current buffer |
| `` `" `` | Jump to position where you last exited this buffer |

**Useful mark commands:**

| Command | Description |
|---|---|
| `:marks` | List all current marks |
| `:delmarks a` | Delete mark "a" |
| `:delmarks!` | Delete all lowercase marks |

**Practical workflow:**
1. You're reading a function and want to bookmark it: press `mA` (global mark A)
2. Navigate elsewhere, do other work
3. Press `` `A `` to jump right back, even from a different file

**Capital letters (A-Z)** are the key for cross-file bookmarks -- they persist across buffers and even across Neovim sessions.

### Jump List (Automatic Bookmarks)

Neovim automatically tracks your jump history:

| Keybinding | Description |
|---|---|
| `<C-o>` | Jump back (previous location) |
| `<C-i>` | Jump forward (next location) |
| `:jumps` | Show the full jump list |

This is incredibly useful -- every time you jump to a definition, search result, or mark, the previous location is saved automatically.

### Flash.nvim (Fast Motion)

LazyVim includes **flash.nvim** for quick jumping anywhere on screen:

| Keybinding | Description |
|---|---|
| `s` | Flash jump -- type 1-2 chars, then a label to jump there |
| `S` | Flash Treesitter -- select treesitter nodes visually |
| `r` (in operator-pending mode) | Remote flash -- apply operator at a distant location |
| `<C-s>` (in search `/` mode) | Toggle flash during search |

**Example:** press `s`, type `us`, and flash will highlight all occurrences of "us" on screen with letter labels. Press the label to jump there instantly.

---

## 7. Code Documentation & Hover (LSP)

This requires an LSP server to be running for your language (LazyVim auto-configures this via Mason).

### Hover Documentation

| Keybinding | Description |
|---|---|
| `K` | **Hover documentation** -- shows what a function/method does (e.g., what `useMemo` does) |
| `K` (press again) | Enters the hover popup so you can scroll/read it |
| `gd` | **Go to definition** -- jump to where the function is defined |
| `gD` | **Go to declaration** |
| `gr` | **Go to references** -- find all usages of the symbol |
| `gI` | **Go to implementation** |
| `gy` | **Go to type definition** |
| `<leader>ca` | Code actions |
| `<leader>cr` | Rename symbol |
| `<leader>cd` | Show line diagnostics (errors/warnings) |

### Signature Help (Function Parameters)

| Keybinding | Description |
|---|---|
| `gK` | Signature help (show parameter info while looking at a function call) |
| `<C-k>` (in insert mode) | Signature help while typing |

### Example: Reading `useMemo` documentation

1. Place your cursor on `useMemo`
2. Press `K` -- a floating window appears with the TypeScript documentation
3. Press `K` again to enter the popup and scroll through the docs
4. Press `q` or `<Esc>` to close it

---

## 8. Window & Split Navigation

| Keybinding | Description |
|---|---|
| `<C-h>` | Go to left window |
| `<C-j>` | Go to lower window |
| `<C-k>` | Go to upper window |
| `<C-l>` | Go to right window |
| `<leader>-` | Horizontal split |
| `<leader>\|` | Vertical split |
| `<leader>wd` | Delete/close window |
| `<leader>wm` | Maximize current window (toggle) |

### Resizing Windows

| Keybinding | Description |
|---|---|
| `<C-Up>` | Increase height |
| `<C-Down>` | Decrease height |
| `<C-Left>` | Decrease width |
| `<C-Right>` | Increase width |

---

## 9. Tabs

| Keybinding | Description |
|---|---|
| `<leader><tab>l` | Last tab |
| `<leader><tab>o` | Close other tabs |
| `<leader><tab>f` | First tab |
| `<leader><tab><tab>` | New tab |
| `<leader><tab>d` | Close tab |
| `<leader><tab>]` | Next tab |
| `<leader><tab>[` | Previous tab |

---

## 10. Which-Key (Discover All Keybindings)

Not sure what a key does? LazyVim includes **which-key.nvim**:

- Press `<leader>` and **wait** -- a popup shows all available `<leader>` keybindings grouped by category
- Press `<leader>s` and wait -- shows all search-related keybindings
- Press `g` and wait -- shows all "go to" keybindings

| Keybinding | Description |
|---|---|
| `<leader>sk` | Search all keymaps (fuzzy search through every keybinding) |
| `<leader>sh` | Search help pages |

---

## 11. Quick Reference: Most Used Workflows

### "I want to open a file I know the name of"
`<leader>ff` --> type the filename --> Enter

### "I want to search for text across the whole project"
`<leader>sg` (or `<leader>/`) --> type search term --> navigate results

### "I want to bookmark a spot and come back later"
`mA` to set mark --> do other work --> `` `A `` to jump back

### "I want to see what a function does"
Cursor on the function --> `K` for docs, `gd` to go to its definition

### "I want to open a terminal quickly"
`Ctrl+/` to toggle a floating terminal

### "I want to go back to where I just was"
`Ctrl+o` to jump back, `Ctrl+i` to jump forward

### "I want to see all files in the project tree"
`<leader>e` to toggle the file explorer

### "I want to find a symbol/function name in the project"
`<leader>ss` for current file, `<leader>sS` for the whole workspace
