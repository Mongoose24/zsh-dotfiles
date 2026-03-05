#!/usr/bin/env bash
set -e

DOTFILES_DIR="$HOME/dotfiles"
GITHUB_REPO="https://github.com/Mongoose24/dotfiles.git"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "==> Updating packages..."
sudo apt-get update -qq

echo "==> Installing core packages..."
sudo apt-get install -y \
    zsh git curl stow fzf ripgrep poppler-utils ffmpeg file unzip wget tree htop jq \
    chafa rsync

echo "==> Installing fastfetch..."
if ! apt-cache show fastfetch &>/dev/null; then
    sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
    sudo apt-get update -qq
fi
sudo apt-get install -y fastfetch

echo "==> Installing zoxide..."
if apt-cache show zoxide &>/dev/null; then
    sudo apt-get install -y zoxide
else
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

echo "==> Installing bat..."
if apt-cache show bat &>/dev/null; then
    sudo apt-get install -y bat
else
    BAT_VERSION=$(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
    curl -Lo /tmp/bat.deb "https://github.com/sharkdp/bat/releases/download/${BAT_VERSION}/bat_${BAT_VERSION#v}_amd64.deb"
    sudo dpkg -i /tmp/bat.deb
    rm /tmp/bat.deb
fi

echo "==> Installing fd (fast find)..."
if apt-cache show fd-find &>/dev/null; then
    sudo apt-get install -y fd-find
    # symlink fdfind to fd so it works as expected
    sudo ln -sf $(which fdfind) /usr/local/bin/fd
else
    sudo apt-get install -y fd
fi

echo "==> Building and Installing yazi..."
YAZI_VERSION=$(curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
curl -Lo /tmp/yazi.zip "https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-x86_64-unknown-linux-gnu.zip"
unzip -q /tmp/yazi.zip -d /tmp/yazi
sudo mv /tmp/yazi/yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/
sudo mv /tmp/yazi/yazi-x86_64-unknown-linux-gnu/ya /usr/local/bin/
rm -rf /tmp/yazi.zip /tmp/yazi

echo "==> Clearing MOTD and login messages..."
truncate -s 0 /etc/motd
truncate -s 0 /etc/issue
truncate -s 0 /etc/issue.net
rm -f /etc/update-motd.d/10-uname

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
stow config

echo "==> Creating local functions dir..."
mkdir -p "$HOME/.oh-my-zsh/custom/local-functions"

echo "==> Setting default shell to zsh..."
chsh -s "$(which zsh)"

echo ""
echo "✓ All done! Run: exec zsh"
