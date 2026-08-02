so now i am making an an an an an an  edit

# Neovim Configuration Guide

This directory contains a modular Neovim configuration based on kickstart.nvim.

## Layout

- `init.lua`: Bootstrap only. It loads modules in dependency order. Keep this file minimal.
- `lua/config/options.lua`: Global editor options, leader keys, clipboard, appearance, and behavior.
- `lua/config/keymaps.lua`: General keymaps and diagnostic display settings.
- `lua/config/autocmds.lua`: General autocommands, such as yank highlighting.
- `lua/config/pack.lua`: Packer setup, plugin declarations, and build steps.
- `lua/config/plugins.lua`: Loads plugin configuration after Packer has installed the plugin set.
- `lua/plugins/ui.lua`: Catppuccin, statusline, Which-Key, Git signs, mini.nvim, and other UI plugins.
- `lua/plugins/undotree.lua`: UndoTree toggle mapping.
- `lua/plugins/telescope.lua`: Telescope setup and search/LSP picker mappings.
- `lua/plugins/lsp.lua`: Language servers, Mason, Fidget, LSP settings, and LSP-specific mappings.
- `lua/plugins/formatting.lua`: Conform formatting configuration and format mapping.
- `lua/plugins/completion.lua`: LuaSnip and blink.cmp configuration.
- `lua/plugins/treesitter.lua`: Treesitter parser installation and FileType parser attachment.

## Where to Make Changes


 in `lua/config/pack.lua`, then configure it in a focused file under `lua/plugins/`.
- Add or configure a language server in `lua/plugins/lsp.lua`.
- Add formatter behavior in `lua/plugins/formatting.lua`.
- Add completion or snippet behavior in `lua/plugins/completion.lua`.
- Add parser behavior in `lua/plugins/treesitter.lua`.
- Change the theme or transparency in `lua/plugins/ui.lua`.
- Change UndoTree behavior or its mapping in `lua/plugins/undotree.lua`.

## Rules

1. Do not put plugin configuration directly in `init.lua`.
2. Keep modules focused; do not create one giant replacement file.
3. Load `config.options` before plugins so leader keys and global options are available.
4. Load `config.pack` before plugin modules so Packer is initialized first.
5. Add and manage plugins only in `lua/config/pack.lua`; keep plugin setup in the matching file under `lua/plugins/`.
6. Prefer existing plugins and keymap groups before adding new dependencies.
7. Keep the terminal background transparent unless explicitly changing the theme behavior.
8. Preserve the Spacebar as the leader key unless intentionally changing all leader mappings.
9. Avoid adding tutorial or explanatory comment blocks. Use short comments only when a setting is non-obvious.

## Packer Commands
Use these commands inside Neovim:

UUUUse these comUse these commands inside Neovim:
Use these commands inside Neovim:
Use these commands inside Neovim:
Use these commands inside Neovim:
Use these commands inside Neovim:
Use these commands inside Neovim:
Use these commands inside Neovim:
mands inside Neovim:
se these commands inside Neovim:
se these commands inside Neovim:
se these commands inside Neovim:
Use these commands inside Neovim:
Use these commands inside Neovim:
Use these commands inside Neovim:

Use these commands inside Neovim:
Use these commands inside Neovim:

Use these commands inside Neovim:

- `:PackerSync`: install missing plugins and update the compiled plugin file.
- `:PackerUpdate`: update plugins.
- `:PackerClean`: remove plugins no longer declared in `lua/config/pack.lua`.
- `:PackerCompile`: regenerate the compiled plugin loader.
- `:PackerStatus`: inspect plugin state.

## Verification

After changes, run:

```bash
nvim --headless '+qa'
```

For a clean interactive check:

```vim
:checkhealth
```

Useful checks include opening a Lua file, confirming completion and diagnostics work, testing `<leader>sf` for Telescope file search, and checking that the Catppuccin background remains transparent.

TEST EDIT 1
