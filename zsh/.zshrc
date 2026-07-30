# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Starship prompt
eval "$(starship init zsh)"

# Normal theme "robbyrussell"
ZSH_THEME=""

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 14

# Stop ZSH correcting to . files
CORRECT_IGNORE='.*'
CORRECT_IGNORE_FILE='.*'

DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"

plugins=(
        git
        zsh-autosuggestions
        zsh-history-substring-search
        fast-syntax-highlighting
)

FUNCNEST=99
source $ZSH/oh-my-zsh.sh

source $ZSH_CUSTOM/custom.zsh

# Clear screen, keep buffer
clear-keep-buffer() {
    zle clear-screen
}
zle -N clear-keep-buffer
bindkey '^Xl' clear-keep-buffer

export EDITOR=nano
export VISUAL=nano

source /home/lucas/.local/share/leaf/completions/_leaf
