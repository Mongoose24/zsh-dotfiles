#!/usr/bin/env bash
set -e

DOTFILES_DIR="$HOME/dotfiles"
GITHUB_REPO="git@github.com:Mongoose24/dotfiles.git"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "==> Updating packages..."
sudo apt-get update -qq

echo "==> Installing core packages..."
sudo apt-get install -y \
    zsh git curl stow \
    fzf zoxide \
    fastfetch

echo "==> Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "    Oh My Zsh already installed, skipping."
fi

echo "==> Installing OMZ plugins..."

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "    zsh-autosuggestions already installed, skipping."
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
        "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "    zsh-syntax-highlighting already installed, skipping."
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search \
        "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
else
    echo "    zsh-history-substring-search already installed, skipping."
fi

echo "==> Installing Powerlevel10k theme..."
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "$ZSH_CUSTOM/themes/powerlevel10k"
else
    echo "    Powerlevel10k already installed, skipping."
fi

echo "==> Cloning dotfiles..."
if [ ! -d "$DOTFILES_DIR" ]; then
    git clone "$GITHUB_REPO" "$DOTFILES_DIR"
else
    echo "    Dotfiles already cloned, pulling latest..."
    git -C "$DOTFILES_DIR" pull
fi

echo "==> Stowing dotfiles..."
cd "$DOTFILES_DIR"

# Backup and remove any existing files that would block stow
[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak" && echo "    Backed up existing .zshrc"
[ -f "$HOME/.p10k.zsh" ] && mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak" && echo "    Backed up existing .p10k.zsh"

stow zsh
stow p10k
# stow config  # uncomment when you're ready to manage ~/.config

echo "==> Creating empty functions dir..."
mkdir -p "$HOME/.oh-my-zsh/custom/functions"

echo "==> Setting default shell to zsh..."
chsh -s "$(which zsh)"

echo ""
echo "✓ All done! Run: exec zsh"
