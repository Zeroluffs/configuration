# Markdown-Oxide Primer

A practical guide to what just landed in your LazyVim config and how to get the most out of it.

## What changed

Two files were touched:

- **`lazyvim.json`** — enabled `lazyvim.plugins.extras.lang.markdown`, the first-party LazyVim markdown bundle.
- **`lua/plugins/markdown-oxide.lua`** — swapped the default `marksman` LSP for [`markdown-oxide`](https://github.com/Feel-ix-343/markdown-oxide) and set the workspace capability it needs for refactoring.

### What the markdown extra brings in

| Tool | Purpose |
|---|---|
| `render-markdown.nvim` | In-buffer pretty rendering (headings, code fences, tables) |
| `markdown-preview.nvim` | Live browser preview |
| `markdownlint-cli2` | Linting (via `nvim-lint`) |
| `markdown-toc` | Auto-generate TOC on a `<!-- toc -->` line |
| `prettier` | Formatting |
| Treesitter `markdown` + `markdown_inline` | Syntax/structure parsing |

### Where markdown-oxide fits

Marksman gave you basic link/heading navigation. Markdown-oxide is a **PKM-grade** LSP — it's built for note-taking workflows (Obsidian, Logseq, Zettelkasten). You get everything marksman did, plus:

- `[[wikilinks]]` completion and navigation
- `#tags` as first-class symbols
- Daily notes (`[[2026-04-17]]`, or `[[today]]`, `[[tomorrow]]`, `[[next monday]]`)
- Backlinks via `gr` (references)
- Block references (`[[note#^blockid]]`)
- Rename that rewrites every inbound link
- Document/workspace symbols for your whole vault

## First-run checklist

1. Open Neovim. Lazy will fetch the new plugins.
2. Run `:Mason` — you should see **markdown-oxide** download (a small Rust binary, no toolchain needed).
3. Open any `.md` file. Confirm with `:LspInfo` that `markdown_oxide` is attached and `marksman` is not.
4. (Optional) Create a `.moxide.toml` at your notes root to tune settings. See below.

## The keybinds you already have

LazyVim's global LSP keymaps work out of the box on markdown buffers now:

| Keys | Action |
|---|---|
| `gd` | Jump to the definition of a link, heading, or tag |
| `gr` | List backlinks / references |
| `K` | Hover preview of the linked note |
| `<leader>cr` | Rename heading / note / tag (updates all links) |
| `<leader>ca` | Code actions (create missing note, insert daily note, etc.) |
| `<leader>cl` | LSP info |
| `<leader>co` | Source actions |
| `<leader>cp` | Markdown preview in browser |
| `<leader>um` | Toggle pretty rendering |

Plus your normal completion popup fires inside `[[`, `[`, and `#` contexts.

## Workflows

### Linking notes

Start typing `[[` and completion proposes every note in the workspace. Accept with `<CR>`. Jump with `gd`. Rename the target with `<leader>cr` — markdown-oxide rewrites every inbound link.

### Daily notes

Inside `[[ ]]`, type natural-language dates:

```
[[today]]         → [[2026-04-17]]
[[tomorrow]]
[[next monday]]
[[3 days ago]]
```

When you follow the link (`gd`) to a note that doesn't exist yet, use `<leader>ca` → "Create" to materialize the file.

### Tags

Type `#` and completion suggests existing tags from the workspace. `gd` on a tag shows everywhere it's used.

### Block references

Put `^some-id` at the end of a paragraph, then link to it with `[[note#^some-id]]`. Handy for quoting a specific block.

### Headings

`[[note#Heading Name]]` links directly to a heading. Renaming the heading with `<leader>cr` updates every reference.

## Configuring the vault

Markdown-oxide treats the workspace root (first `.git` or the cwd) as your vault. To customize, drop a `.moxide.toml` at the vault root:

```toml
# Daily notes location relative to vault root
daily_notes_folder = "dailies"

# Format for new daily note filenames
dailies_filename_format = "%Y-%m-%d"

# Heading levels to expose as completion targets
heading_completions = true

# New-file template
new_file_folder_path = "inbox"
```

Full options: <https://github.com/Feel-ix-343/markdown-oxide#configuration>.

## Tips that aren't obvious

- **Open multiple notes as one workspace.** Markdown-oxide scans the whole root, so `cd ~/notes && nvim` gives richer completion than `nvim one-file.md`.
- **`gr` is a killer feature.** Land on a note's `# Title` and hit `gr` to see every note linking to it — that's your backlink panel, no sidebar needed.
- **Rename is transactional.** If you rename a heading referenced by 50 notes, every edit lands in one LSP call. Use `:messages` if something looks off.
- **Don't fight the formatter.** Prettier will reformat link spacing. If you wikilink-heavy and prettier mangles them, add `"prose-wrap": "preserve"` to `.prettierrc` or disable prettier for markdown in a `conform.nvim` override.
- **`render-markdown.nvim` hides syntax as you move past a line.** Toggle with `<leader>um` if you want raw source for editing link targets.
- **Workspace symbols beat file search for notes.** `<leader>sS` (LSP workspace symbols) lists every heading in every note — faster than grep when you remember the title but not the file.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `markdown_oxide` not attaching | `:Mason` → confirm installed. `:LspLog` for errors. |
| Completion empty inside `[[` | Workspace has no `.md` files yet — create one and retry. |
| Links not updating on rename | Check `:LspInfo` shows `workspace/didChangeWatchedFiles` dynamic-registered. The plugin spec sets this; if you further override `capabilities`, merge don't replace. |
| Both marksman and markdown-oxide attached | You overrode `marksman = { enabled = false }` somewhere else. Inspect with `:Lazy` → nvim-lspconfig → show opts. |
| Prettier undoes link formatting | Disable prettier for markdown or tune `.prettierrc`. |

## Uninstalling / switching back

Delete `lua/plugins/markdown-oxide.lua` and remove `"lazyvim.plugins.extras.lang.markdown"` from `lazyvim.json`. Run `:Mason` → `X` on `markdown-oxide` to remove the binary.

## References

- Markdown-Oxide: <https://github.com/Feel-ix-343/markdown-oxide>
- LazyVim markdown extra: <https://www.lazyvim.org/extras/lang/markdown>
- Configuration options: <https://github.com/Feel-ix-343/markdown-oxide#configuration>
