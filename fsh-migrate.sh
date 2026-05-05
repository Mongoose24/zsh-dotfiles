#!/usr/bin/env bash
# One-time migration: zsh-syntax-highlighting -> fast-syntax-highlighting
set -e

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "==> Removing zsh-syntax-highlighting..."
    rm -rf "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "    zsh-syntax-highlighting not found, skipping removal."
fi

if [ ! -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ]; then
    echo "==> Installing fast-syntax-highlighting..."
    git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting \
        "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
else
    echo "    fast-syntax-highlighting already installed, skipping."
fi

echo "==> Done. Run: source ~/.zshrc"
