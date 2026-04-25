#!/usr/bin/env bash
set -e

echo "==> Removing old dotfiles symlinks..."
rm -rf ~/.zshrc ~/.p10k.zsh ~/.config
rm -f ~/.oh-my-zsh/custom/aliases.zsh \
      ~/.oh-my-zsh/custom/custom.zsh \
      ~/.oh-my-zsh/custom/functions

echo "==> Removing old dotfiles repo..."
rm -rf ~/dotfiles

echo "==> Running install script..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
bash "$SCRIPT_DIR/deb-in.sh"
