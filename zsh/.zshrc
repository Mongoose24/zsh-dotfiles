# typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
# Enable Powerlevel10k instant prompt (add near the top)
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

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

# Conditional plugins (truanas compatibility)
FZF_CTRL_R_COMMAND=''
if command -v fzf &>/dev/null; then
    plugins=(
        git
        fzf
        zsh-autosuggestions
        zsh-history-substring-search
        zsh-syntax-highlighting
    )
else
    plugins=(
        git
        zsh-autosuggestions
        zsh-history-substring-search
        zsh-syntax-highlighting
    )
fi

source $ZSH/oh-my-zsh.sh

# Powerlevel10k customization (multi-locational)
if [[ -f /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]]; then
    source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
elif [[ -f ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme ]]; then
    source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
elif command -v brew &>/dev/null && [[ -f $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme ]]; then
    source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source $ZSH_CUSTOM/custom.zsh

# Clear screen, keep buffer
clear-keep-buffer() {
    zle clear-screen
}
zle -N clear-keep-buffer
bindkey '^Xl' clear-keep-buffer

export EDITOR=nano
export VISUAL=nano

# export LANG=en_US.UTF-8
# export MANPATH="/usr/local/man:$MANPATH"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"
# CASE_SENSITIVE="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# HIST_STAMPS="mm/dd/yyyy"

# COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
