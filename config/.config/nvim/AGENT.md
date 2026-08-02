# Neovim Configuration Guide

This is a modular, cross-platform Neovim configuration for macOS, Arch Linux, and Debian/Ubuntu systems. It targets **Neovim 0.12 or newer** because the current Treesitter `main` branch and several core APIs require it.

## Startup and Layout

`init.lua` checks the Neovim version, loads core configuration, then bootstraps lazy.nvim. Plugin files are lazy.nvim specs and own their related setup, mappings, and autocommands.

- `init.lua`: Minimal entrypoint and load order.
- `lua/config/options.lua`: Editor options, XDG state directories, Nerd Font flag, and clipboard policy.
- `lua/config/keymaps.lua`: General, migration-friendly mappings.
- `lua/config/diagnostics.lua`: Global diagnostic display and jump behavior.
- `lua/config/autocmds.lua`: General autocommands.
- `lua/config/lazy.lua`: Cross-platform lazy.nvim bootstrap and manager settings.
- `lua/config/tools.lua`: Shared executable, compiler, and Tree-sitter CLI checks.
- `lua/config/health.lua`: Checks exposed through `:checkhealth config`.
- `lua/plugins/editing.lua`: Guess Indent, TODO Comments, mini.ai, mini.icons, and mini.surround.
- `lua/plugins/git.lua`: Gitsigns.
- `lua/plugins/ui.lua`: Which-Key, Catppuccin, and lualine.
- `lua/plugins/undotree.lua`: UndoTree behavior and mapping.
- `lua/plugins/telescope.lua`: Telescope, optional native FZF, search mappings, and LSP pickers.
- `lua/plugins/lsp.lua`: Mason, `lua_ls`, Fidget, LSP capabilities, and LSP autocommands.
- `lua/plugins/formatting.lua`: Conform, StyLua, and the manual format mapping.
- `lua/plugins/completion.lua`: blink.cmp and LuaSnip.
- `lua/plugins/treesitter.lua`: Parser list, installation, updates, and attachment.
- `lazy-lock.json`: Reproducible plugin revisions; never edit it by hand.

The old Packer configuration, generated loader, and unrelated `nvim-pack-lock.json` were removed. Generated plugin code must not be committed because it can contain machine-specific paths.

## Platform Requirements

Required on every machine:

- Neovim 0.12+
- Git
- `curl` and `tar`
- `tree-sitter` CLI 0.26.1+
- A C compiler
- `unzip` for Mason packages

Recommended:

- `make` for Telescope FZF and LuaSnip regexp support
- `ripgrep` for Telescope live grep and TODO searches
- `fd`; Debian's `fdfind` executable is detected automatically
- A Nerd Font; set `NVIM_NERD_FONT=0` before starting Neovim for ASCII fallbacks

Typical package setup:

### macOS

```bash
xcode-select --install
brew install neovim git ripgrep fd tree-sitter
```

`pbcopy` and `pbpaste` are built in.

### Arch Linux

```bash
sudo pacman -S neovim git base-devel curl tar unzip tree-sitter-cli ripgrep fd
```

Add `wl-clipboard` on Wayland or `xclip`/`xsel` on X11.

### Debian/Ubuntu

```bash
sudo apt install git build-essential curl tar unzip ripgrep fd-find
```

Add `wl-clipboard` on Wayland or `xclip`/`xsel` on X11. Distribution repositories may provide an older Neovim or Tree-sitter CLI; install Neovim 0.12+ from an upstream package and, if necessary, install Tree-sitter CLI 0.26.1+ with the system package manager or Cargo rather than npm.

## Platform Behavior

- Persistent undo and swap files use `stdpath("state")`, not hardcoded home-directory paths.
- Neovim's built-in clipboard provider is used instead of OS-specific command shims.
- `unnamedplus` is enabled only when a local macOS, Wayland, or X11 provider is detected.
- Remote/headless sessions leave the clipboard option empty so Neovim can use OSC 52 when available.
- Telescope uses `fd`, falls back to Debian's `fdfind`, then falls back to Telescope's normal search behavior.
- Native optional plugins are enabled only when `make` and a compiler are present.
- Treesitter installs only the declared parser list; opening an unrelated filetype does not trigger a download.

## Plugin Workflows

Inside Neovim:

- `:Lazy`: inspect plugin state.
- `:Lazy sync`: install, update, clean, and regenerate `lazy-lock.json`.
- `:Lazy restore`: restore revisions from `lazy-lock.json`.
- `:Mason`: inspect language tools.
- `:MasonToolsInstall`: install declared non-LSP tools such as StyLua.
- `:TSUpdate`: update installed Treesitter parsers after plugin updates.
- `:ConformInfo`: inspect formatter availability.

`lua_ls` is the only enabled language server. StyLua is the only configured external formatter. `<leader>f` formats manually; format-on-save is intentionally not enabled.

## Where to Make Changes

- Core behavior: `lua/config/options.lua`
- General mappings: `lua/config/keymaps.lua`
- Diagnostic presentation: `lua/config/diagnostics.lua`
- General autocommands: `lua/config/autocmds.lua`
- Plugins: add or modify a focused spec under `lua/plugins/`
- Language servers and Mason tools: `lua/plugins/lsp.lua`
- Formatters: `lua/plugins/formatting.lua`
- Treesitter parsers: `lua/plugins/treesitter.lua`
- Theme/statusline: `lua/plugins/ui.lua`

After changing plugins, run `:Lazy sync` and commit the resulting `lazy-lock.json` update.

## Configuration Rules

1. Keep `init.lua` minimal and preserve its core-before-plugins load order.
2. Put plugin declarations and setup in focused files under `lua/plugins/`.
3. Use `stdpath()` for data, state, cache, and config paths; never hardcode a username or Linux-only home path.
4. Check optional executables before depending on native builds or OS helpers.
5. Use named, cleared augroups so configuration can be re-sourced safely.
6. Do not commit generated plugin loaders or plugin installation directories.
7. Preserve Space as the leader unless all leader mappings are intentionally migrated.
8. Keep the Catppuccin background transparent unless explicitly changing the theme behavior.
9. Prefer short comments only where behavior is non-obvious.

## Mapping and Practice Caveats

These are intentional or migration-friendly choices, but may matter later:

- `<M-a>` depends on the terminal sending Option/Alt as Meta; macOS terminal settings often need adjustment.
- `<C-S-c>` is indistinguishable from `<C-c>` in some terminals. A leader-based copy mapping is safer if this causes trouble.
- Visual `<LeftRelease>` copies to the system clipboard and ends the visible selection.
- Arrow keys are disabled only in Normal/Visual/Select modes, not Insert or command-line modes.
- `<C-h/j/k/l>` replaces native Normal-mode behaviors such as `<C-l>` redraw with window navigation.
- mini.surround uses the `s` prefix and intentionally replaces native Normal/Visual `s`; `cl` remains available.
- mini.ai uses `g[`/`g]`, which replaces native tag-selection behavior. Its next-object mappings are `aN`/`iN` so `aa` remains “around argument.”
- `timeoutlen=300` makes leader and plugin sequences responsive but can feel short while learning them.
- On local desktops, `unnamedplus` means ordinary yanks, deletes, and puts interact with the system clipboard.
- blink.cmp's default preset contextually uses common insert-mode keys such as `<C-n>`, `<C-p>`, `<Tab>`, and `<C-k>`.

These caveats are not reasons to remove the mappings automatically; change them only when they cause a real conflict.

## Verification

First confirm which config is active:

```vim
:echo stdpath('config')
```

The repository directory and `~/.config/nvim` were separate directories when this audit was performed, so normal `nvim` startup does not validate repository changes until the dotfiles are deployed or linked.

After deployment, run:

```bash
nvim --headless '+qa'
```

Then run interactively:

```vim
:checkhealth config
:checkhealth lazy
:checkhealth nvim-treesitter
:checkhealth telescope
:checkhealth mason
:checkhealth vim.lsp
```

Also open a Lua file and verify diagnostics/completion, `<leader>sf`, `<leader>sg`, `<leader>f`, `<leader>u`, clipboard copy, and transparent Catppuccin rendering.
