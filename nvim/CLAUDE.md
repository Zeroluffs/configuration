# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration based on kickstart.nvim. It is a single-entrypoint Lua config (`init.lua`) with modular custom plugins.

## Formatting

Lua files are formatted with **StyLua**. Configuration is in `.stylua.toml`:
- 160 column width, 2-space indentation, single quotes, no call parentheses, collapse simple statements

Run the formatter:
```sh
stylua .
```

Check formatting without writing:
```sh
stylua --check .
```

## Architecture

- `init.lua` — Main config file. Contains all core settings, keymaps, autocommands, and the `lazy.nvim` plugin manager setup with inline plugin specs (gitsigns, which-key, telescope, nvim-lspconfig, conform, blink.cmp, tokyonight, todo-comments, mini.nvim, treesitter).
- `lua/custom/plugins/*.lua` — Custom plugin specs auto-imported via `{ import = 'custom.plugins' }` in the lazy.nvim setup. Each file returns a lazy.nvim plugin spec table. This is where new plugins should be added.
- `lua/kickstart/plugins/` — Optional bundled plugin configs from upstream kickstart. Enabled/disabled by uncommenting `require` lines in `init.lua` (around line 938-943). Currently only `autopairs` is enabled.

## Key Conventions

- Leader key is `<Space>`
- Plugin management: lazy.nvim (`:Lazy` to manage, `:Mason` for LSP servers/tools)
- LSP servers are configured in the `servers` table inside the `nvim-lspconfig` config function in `init.lua` (around line 616). Currently enabled: `ts_ls`, `intelephense`, `lua_ls`, `stylua`
- Format-on-save is enabled via conform.nvim (disabled for C/C++)
- Colorscheme: tokyonight-night with transparency enabled

## Adding a New Plugin

Create a new file `lua/custom/plugins/<name>.lua` that returns a lazy.nvim plugin spec. It will be auto-loaded.
