#!/usr/bin/env bash
set -e

DOTFILES_DIR="$HOME/dotfiles"
GITHUB_REPO="https://github.com/Mongoose24/dotfiles.git"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "==> UPDATING PACKAGES..."
apt install sudo
sudo apt-get update -qq

echo "==> INSTALLING CORE PACKAGES..."
sudo apt-get install -y \
    sudo zsh git curl stow fzf ripgrep poppler-utils ffmpeg file unzip wget tree htop jq \
    chafa rsync

# checking if fzf needs extra setup
if [ -d /usr/share/doc/fzf/examples ] && [ ! -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
    sudo touch /usr/share/doc/fzf/examples/key-bindings.zsh
    sudo touch /usr/share/doc/fzf/examples/completion.zsh
fi

echo "==> INSTALLING FASTFETCH..."
if ! apt-cache show fastfetch &>/dev/null; then
    if command -v add-apt-repository &>/dev/null && grep -q "Ubuntu" /etc/os-release; then
        sudo apt-get install -y software-properties-common
        sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
        sudo apt-get update -qq
        sudo apt-get install -y fastfetch
    else
        FF_VERSION=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
        curl -Lo /tmp/fastfetch.deb "https://github.com/fastfetch-cli/fastfetch/releases/download/${FF_VERSION}/fastfetch-linux-amd64.deb"
        sudo dpkg -i /tmp/fastfetch.deb
        rm /tmp/fastfetch.deb
    fi
else
    sudo apt-get install -y fastfetch
fi

echo "==> INSTALLING ZOXIDE..."
if apt-cache show zoxide &>/dev/null; then
    ZOXIDE_APT_VERSION=$(apt-cache show zoxide | grep Version | head -1 | awk '{print $2}')
    # if version is too old, install manually
    if dpkg --compare-versions "$ZOXIDE_APT_VERSION" lt "0.9.0"; then
        curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    else
        sudo apt-get install -y zoxide
    fi
else
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

echo "==> INSTALLING BAT..."
if apt-cache show bat &>/dev/null; then
    sudo apt-get install -y bat
else
    BAT_VERSION=$(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
    curl -Lo /tmp/bat.deb "https://github.com/sharkdp/bat/releases/download/${BAT_VERSION}/bat_${BAT_VERSION#v}_amd64.deb"
    sudo dpkg -i /tmp/bat.deb
    rm /tmp/bat.deb
fi

echo "==> INSTALLING FD..."
if apt-cache show fd-find &>/dev/null; then
    sudo apt-get install -y fd-find
    # symlink fdfind to fd so it works as expected
    sudo ln -sf $(which fdfind) /usr/local/bin/fd
else
    sudo apt-get install -y fd
fi

echo "==> INSTALLING YAZI..."
YAZI_VERSION=$(curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
curl -Lo /tmp/yazi.zip "https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-x86_64-unknown-linux-gnu.zip"
unzip -q /tmp/yazi.zip -d /tmp/yazi
sudo mv /tmp/yazi/yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/
sudo mv /tmp/yazi/yazi-x86_64-unknown-linux-gnu/ya /usr/local/bin/

echo "==> Cleaning up temp files..."
rm -f /tmp/bat.deb
rm -f /tmp/fastfetch.deb
rm -rf /tmp/yazi.zip /tmp/yazi
rm -rf /tmp/yazi.zip /tmp/yazi

echo "==> CLEARNING  MOTD AND LOGIN MESSAGES..."
sudo truncate -s 0 /etc/motd
sudo truncate -s 0 /etc/issue
sudo truncate -s 0 /etc/issue.net
sudo rm -f /etc/update-motd.d/*

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

echo "==> INSTALLING P10K THEME..."
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "$ZSH_CUSTOM/themes/powerlevel10k"
else
    echo "    Powerlevel10k already installed, skipping."
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

# Backup and remove any existing files that would block stow
[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak" && echo "    Backed up existing .zshrc"
[ -f "$HOME/.p10k.zsh" ] && mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak" && echo "    Backed up existing .p10k.zsh"

stow zsh
stow p10k
stow config

echo "==> CREATING LOCAL-FUNCTIONS DIR..."
mkdir -p "$HOME/.oh-my-zsh/custom/local-functions"

echo "==> SETTING DEFAULT SHELL TO ZSH..."
chsh -s "$(which zsh)"

echo ""
echo "✓ ALL DONE! Run: exec zsh"
