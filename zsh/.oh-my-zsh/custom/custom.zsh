# custom ZSH stuff goes here i guess

export PATH="$HOME/.local/bin:$PATH"
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Zoxide
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# Atuin
if command -v atuin &>/dev/null; then
    eval "$(atuin init zsh --disable-up-arrow)"
fi



# Add custom functions directory to fpath and autoload everything in /functions (with silent fail)
fpath+=($ZSH_CUSTOM/functions)
[[ -n "$(ls $ZSH_CUSTOM/functions 2>/dev/null)" ]] && autoload -Uz $ZSH_CUSTOM/functions/*

fpath+=($ZSH_CUSTOM/local-functions)
[[ -n "$(ls $ZSH_CUSTOM/local-functions 2>/dev/null)" ]] && autoload -Uz $ZSH_CUSTOM/local-functions/*

# Load local zsh if present
[[ -f ~/.oh-my-zsh/custom/local-functions/local-zsh.zsh ]] && source ~/.oh-my-zsh/custom/local-functions/local-zsh.zsh

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Menu selection (arrow keys to choose)
zstyle ':completion:*' menu select

# Group results
zstyle ':completion:*' group-name ''

# Colorize completions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Complete directories with trailing slash
zstyle ':completion:*' squeeze-slashes true

# Fish like auto-suggest
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true

# fzf directory jump (alt-d) and file open (shift-alt-d)
zle -N fzf-dir
zle -N fzf-file
bindkey '\Ed' fzf-dir
bindkey '\ED' fzf-file

# Vibe keys
export MISTRAL_API_KEY="i1mK69RbzemrOtKidxIynidy5ZyPcqQL"
export CEREBRAS_API_KEY="csk-m5k3w8f4c4c8kppp2xjf9me3jwvjvxmnedyy9jk8ym6pjcxj"


# XTERM-GHOSTTY ONLY Shift+left/right
# bindkey "^[[1;2D" backward-word
# bindkey "^[[1;2C" forward-word
