#!/usr/bin/env bash
set -e

DOTFILES_DIR="$HOME/zsh-dotfiles"
GITHUB_REPO="https://github.com/Mongoose24/zsh-dotfiles.git"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "==> REMOVING OLD DOTFILES SYMLINKS..."
rm -f "$HOME/.zshrc" "$HOME/.p10k.zsh"
rm -f "$ZSH_CUSTOM/aliases.zsh" "$ZSH_CUSTOM/custom.zsh" "$ZSH_CUSTOM/functions"
rm -f "$HOME/.config/nano/glsl.nanorc" "$HOME/.config/nano/toml.nanorc" "$HOME/.config/nano/nanorc"
rm -f "$HOME/.config/yazi/yazi.toml" "$HOME/.config/yazi/keymap.toml"
rm -f "$HOME/.config/atuin/config.toml"
rm -f "$HOME/.config/micro/bindings.json" "$HOME/.config/micro/settings.json"

echo "==> REMOVING OLD DOTFILES REPO..."
rm -rf "$HOME/dotfiles"

echo "==> CLONING DOTFILES..."
if [ ! -d "$DOTFILES_DIR" ]; then
    git clone "$GITHUB_REPO" "$DOTFILES_DIR"
else
    echo "    Already cloned, pulling latest..."
    git -C "$DOTFILES_DIR" pull
fi

echo "==> STRIPPING ATUIN AUTO-APPENDED LINES FROM ZSHRC..."
sed -i '/\. "\$HOME\/.atuin\/bin\/env"/d; /eval "\$(atuin init zsh)"/d' "$DOTFILES_DIR/zsh/.zshrc"

echo "==> SYMLINKING DOTFILES..."
ln -sf "$DOTFILES_DIR/zsh/.zshrc"                              "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/p10k/.p10k.zsh"                         "$HOME/.p10k.zsh"
ln -sf "$DOTFILES_DIR/zsh/.oh-my-zsh/custom/aliases.zsh"      "$ZSH_CUSTOM/aliases.zsh"
ln -sf "$DOTFILES_DIR/zsh/.oh-my-zsh/custom/custom.zsh"       "$ZSH_CUSTOM/custom.zsh"
ln -sf "$DOTFILES_DIR/zsh/.oh-my-zsh/custom/functions"        "$ZSH_CUSTOM/functions"

# config — link per-file, .config dir already exists on TrueNAS
mkdir -p "$HOME/.config/nano" "$HOME/.config/yazi" "$HOME/.config/atuin" "$HOME/.config/micro"
ln -sf "$DOTFILES_DIR/config/.config/nano/glsl.nanorc"        "$HOME/.config/nano/glsl.nanorc"
ln -sf "$DOTFILES_DIR/config/.config/nano/toml.nanorc"        "$HOME/.config/nano/toml.nanorc"
ln -sf "$DOTFILES_DIR/config/.config/nano/nanorc"             "$HOME/.config/nano/nanorc"
ln -sf "$DOTFILES_DIR/config/.config/yazi/yazi.toml"          "$HOME/.config/yazi/yazi.toml"
ln -sf "$DOTFILES_DIR/config/.config/yazi/keymap.toml"        "$HOME/.config/yazi/keymap.toml"
ln -sf "$DOTFILES_DIR/config/.config/atuin/config.toml"       "$HOME/.config/atuin/config.toml"
ln -sf "$DOTFILES_DIR/config/.config/micro/bindings.json"     "$HOME/.config/micro/bindings.json"
ln -sf "$DOTFILES_DIR/config/.config/micro/settings.json"     "$HOME/.config/micro/settings.json"

echo "==> INSTALLING FZF..."
rm -rf "$HOME/.fzf"
if command -v fzf &>/dev/null; then
    echo "    fzf already installed, skipping."
else
    FZF_URL=$(curl -sf https://api.github.com/repos/junegunn/fzf/releases/latest | grep 'browser_download_url.*linux_amd64\.tar\.gz' | cut -d'"' -f4)
    curl -fLo /tmp/fzf.tar.gz "$FZF_URL"
    tar -xzf /tmp/fzf.tar.gz -C "$HOME/.local/bin/"
    rm /tmp/fzf.tar.gz
fi

echo "==> INSTALLING DU-DUST..."
if command -v dust &>/dev/null; then
    echo "    du-dust already installed, skipping."
else
    DUST_URL=$(curl -sf https://api.github.com/repos/bootandy/dust/releases/latest | grep 'browser_download_url.*x86_64.*linux.*musl.*tar\.gz' | cut -d'"' -f4)
    if [ -z "$DUST_URL" ]; then echo "    WARNING: could not fetch dust release URL, skipping."; else
        curl -fLo /tmp/dust.tar.gz "$DUST_URL"
        tar -xzf /tmp/dust.tar.gz -C /tmp
        mv /tmp/dust-*/dust "$HOME/.local/bin/"
        rm -rf /tmp/dust.tar.gz /tmp/dust-*
    fi
fi

echo "==> INSTALLING ZOXIDE..."
if command -v zoxide &>/dev/null; then
    echo "    zoxide already installed, skipping."
else
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

echo "==> INSTALLING YAZI..."
if command -v yazi &>/dev/null; then
    echo "    yazi already installed, skipping."
else
    YAZI_VERSION=$(curl -sf https://api.github.com/repos/sxyazi/yazi/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
    curl -fLo /tmp/yazi.zip "https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-x86_64-unknown-linux-musl.zip"
    unzip -q /tmp/yazi.zip -d /tmp/yazi
    mv /tmp/yazi/yazi-x86_64-unknown-linux-musl/yazi "$HOME/.local/bin/"
    mv /tmp/yazi/yazi-x86_64-unknown-linux-musl/ya "$HOME/.local/bin/"
    rm -rf /tmp/yazi.zip /tmp/yazi
fi

echo "==> INSTALLING ATUIN..."
if command -v atuin &>/dev/null; then
    echo "    atuin already installed, skipping."
else
    curl -sSfL https://setup.atuin.sh | sh
    mv "$HOME/.atuin/bin/atuin" "$HOME/.local/bin/"
fi

echo "==> CREATING LOCAL ZSH DIRECTORIES..."
mkdir -p "$ZSH_CUSTOM/local-functions"
LOCAL_ZSH="$ZSH_CUSTOM/local-functions/local-zsh.zsh"
if [ ! -f "$LOCAL_ZSH" ]; then
    touch "$LOCAL_ZSH"
    echo "    Created local-zsh.zsh"
fi

echo ""
echo "✓ ALL DONE! Run: exec zsh"
