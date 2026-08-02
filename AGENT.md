# AGENT.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

GNU Stow-based dotfiles managed across Debian/Arch/macOS machines and Proxmox LXC containers. Each top-level directory is a stow package — `stow <package>` symlinks its contents into `$HOME`.

Current packages:
- `zsh/` — `.zshrc` + all Oh My Zsh custom files (aliases, functions, plugins)
- `tmux/` — `.??` tmux config
- `config/` — `.config/` entries (atuin, nano syntax highlighting, yazi)
- `nano/` — placeholder package (currently empty, reserved for nano dotfiles)

## Applying changes

```bash
# Stow a package (run from ~/dotfiles)
stow zsh
stow tmux
stow config

# Re-stow after adding/moving files
stow -R zsh

# Dry run to check for conflicts
stow -n zsh
```

The install script `deb-in.sh` handles a full fresh Debian setup: installs packages, clones repo, stows packages, and sets zsh as default shell.

## ZSH customization structure

All Oh My Zsh custom files live in `zsh/.oh-my-zsh/custom/`:

| File/Dir | Purpose |
|---|---|
| `aliases.zsh` | Shared aliases across all machines |
| `custom.zsh` | PATH, env vars, tool inits (zoxide, atuin), completions |
| `functions/` | Autoloaded shared functions (`y`, `f`, `sy`, `dotpull`, etc.) |

Machine-local or personal overrides go in `~/.oh-my-zsh/custom/local-functions/` — this directory is **not tracked** by this repo and is never touched by `stow` or `dotpull`.

## Key design rules

- `aliases.zsh` = shared aliases that go to every machine. Keep it conditional where tools may not exist (see the `pacman`/`brew`/`eza` patterns already there).
- `custom.zsh` = env/path/tool init only. Functions go in `functions/`, not here.
- Never put machine-specific config in tracked files — use `local-zsh.zsh` (untracked) for that.
- `functions/` is autoloaded by `custom.zsh`; every file added there is immediately available as a command after `source ~/.zshrc`.

## Deployment workflow

When bootstrapping a new LXC/VM:
```bash
git clone https://github.com/Mongoose24/zsh-dotfiles.git ~/dotfiles
cd ~/zsh-dotfiles && chmod +x deb-in.sh && ./deb-in.sh
exec zsh
```

`zdotpull` (function in `functions/`) pulls latest from this repo on an existing machine — but requires manual backup of any local overrides first.
