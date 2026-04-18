# custom ZSH stuff goes here i guess

export PATH="$HOME/.local/bin:$PATH"

# Zoxide
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# Atuin
if command -v atuin &>/dev/null; then
    eval "$(atuin init zsh --disable-up-arrow)"
fi

# XTERM-GHOSTTY ONLY History substring search arrow bindings
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

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

# XTERM-GHOSTTY ONLY Shift+left/right
# bindkey "^[[1;2D" backward-word
# bindkey "^[[1;2C" forward-word
