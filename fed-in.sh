#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/zsh-dotfiles"
GITHUB_REPO="https://github.com/Mongoose24/zsh-dotfiles.git"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

as_root() {
    if [ "${EUID}" -eq 0 ]; then
        "$@"
    else
        sudo "$@"
    fi
}

if [ "${EUID}" -ne 0 ] && ! command -v sudo &>/dev/null; then
    echo "ERROR: sudo is required when this script is not run as root." >&2
    exit 1
fi

if ! command -v dnf &>/dev/null; then
    echo "ERROR: This installer requires Fedora's dnf package manager." >&2
    exit 1
fi

if [ "$(uname -m)" != "x86_64" ]; then
    echo "ERROR: This installer currently supports x86_64 Fedora systems only." >&2
    exit 1
fi

echo "==> REFRESHING PACKAGE METADATA..."
as_root dnf makecache --refresh -q

# Fedora's ffmpeg-free is limited by patent/licensing restrictions. Replace it
# (when preinstalled) with RPM Fusion Free's full FFmpeg package.
echo "==> ENABLING RPM FUSION FREE (FOR FFMPEG)..."
if ! rpm -q rpmfusion-free-release &>/dev/null; then
    as_root dnf install -y \
        "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
fi
as_root dnf makecache --refresh -q

echo "==> INSTALLING FULL FFMPEG FROM RPM FUSION..."
as_root dnf install -y --allowerasing ffmpeg

echo "==> INSTALLING CORE PACKAGES..."
as_root dnf install -y \
    sudo zsh git curl stow fzf ripgrep poppler-utils file unzip wget2 tree htop jq \
    chafa rsync tmux neovim zoxide bat fd-find du-dust atuin

# Fedora ships GNU Wget 2 as wget2. Keep the familiar command name used by
# most shell documentation when the legacy wget package is unavailable.
if ! command -v wget &>/dev/null && command -v wget2 &>/dev/null; then
    as_root ln -sf "$(command -v wget2)" /usr/local/bin/wget
fi

echo "==> INSTALLING LEAF..."
if ! command -v leaf &>/dev/null; then
    curl -fsSL https://leaf.rivolink.mg/install.sh | sh
else
    echo "    leaf already installed, skipping."
fi

echo "==> INSTALLING YAZI AND PLUGINS..."
if ! command -v yazi &>/dev/null; then
    YAZI_VERSION=$(curl -fsSL https://api.github.com/repos/sxyazi/yazi/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
    curl -fLo /tmp/yazi.zip "https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-x86_64-unknown-linux-musl.zip"
    rm -rf /tmp/yazi
    unzip -q /tmp/yazi.zip -d /tmp/yazi
    as_root install -m 0755 /tmp/yazi/yazi-x86_64-unknown-linux-musl/yazi /usr/local/bin/yazi
    as_root install -m 0755 /tmp/yazi/yazi-x86_64-unknown-linux-musl/ya /usr/local/bin/ya
else
    echo "    yazi already installed, skipping."
fi
ya pkg install 2>/dev/null || true

echo "==> INSTALLING OH MY ZSH..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "    Oh My Zsh already installed, skipping."
fi

echo "==> INSTALLING OMZ PLUGINS..."
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "    zsh-autosuggestions already installed, skipping."
fi

if [ ! -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ]; then
    git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting \
        "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
else
    echo "    fast-syntax-highlighting already installed, skipping."
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search \
        "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
else
    echo "    zsh-history-substring-search already installed, skipping."
fi

echo "==> INSTALLING SESH..."
if ! command -v sesh &>/dev/null; then
    SESH_URL=$(curl -fsSL https://api.github.com/repos/joshmedeski/sesh/releases/latest | grep 'browser_download_url.*Linux_x86_64\.tar\.gz' | cut -d'"' -f4)
    curl -fLo /tmp/sesh.tar.gz "$SESH_URL"
    tar -xzf /tmp/sesh.tar.gz -C /tmp sesh
    as_root install -m 0755 /tmp/sesh /usr/local/bin/sesh
    rm -f /tmp/sesh.tar.gz /tmp/sesh
else
    echo "    sesh already installed, skipping."
fi

echo "==> INSTALLING STARSHIP..."
if ! command -v starship &>/dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
else
    echo "    Starship already installed, skipping."
fi

echo "==> INSTALLING TPM (tmux plugin manager)..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
    echo "    TPM already installed, skipping."
fi

echo "==> CLONING DOTFILES..."
if [ ! -d "$DOTFILES_DIR" ]; then
    git clone "$GITHUB_REPO" "$DOTFILES_DIR"
else
    echo "    Dotfiles already cloned, pulling latest..."
    git -C "$DOTFILES_DIR" pull
fi

echo "==> STOWING DOTFILES..."
cd "$DOTFILES_DIR"

# Backup and remove any existing files that would block stow.
[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak" && echo "    Backed up existing .zshrc"
[ -f "$HOME/.tmux.conf" ] && mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak" && echo "    Backed up existing .tmux.conf"

stow zsh
stow config
stow tmux

echo "==> CONFIGURING NANO..."
mkdir -p "$HOME/.config/nano"
printf '%s\n' 'include /usr/share/nano/*.nanorc' > "$HOME/.config/nano/nanorc"
printf '%s\n' 'include ~/.config/nano/*.nanorc' >> "$HOME/.config/nano/nanorc"

echo "==> CREATING LOCAL ZSH DIRECTORIES..."
mkdir -p "$HOME/.oh-my-zsh/custom/local-functions"
LOCAL_ZSH="$HOME/.oh-my-zsh/custom/local-functions/local-zsh.zsh"
if [ ! -f "$LOCAL_ZSH" ]; then
    touch "$LOCAL_ZSH"
    echo "    Created local-zsh.zsh"
else
    echo "    local-zsh.zsh already exists, skipping."
fi

echo "==> CLEARING MOTD AND LOGIN MESSAGES..."
as_root truncate -s 0 /etc/motd
as_root truncate -s 0 /etc/issue
as_root truncate -s 0 /etc/issue.net
as_root rm -f /etc/update-motd.d/*

echo "==> SETTING DEFAULT SHELL TO ZSH..."
chsh -s "$(command -v zsh)"

echo ""
echo "✓ ALL DONE! Run: exec zsh"
