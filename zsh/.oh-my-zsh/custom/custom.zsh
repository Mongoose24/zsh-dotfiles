# custom ZSH stuff goes here i guess

# Welcome fastfetch message (uncomment if you want to use it)
if [ "$(ps -o ppid= -p $$)" != "$(cat /tmp/term_session_ppid_$UID 2>/dev/null)" ]; then
    ps -o ppid= -p $$ > /tmp/term_session_ppid_$UID
    fastfetch
fi

# Zoxide
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi
export PATH="$HOME/.local/bin:$PATH"

# XTERM-GHOSTTY ONLY History substring search arrow bindings
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# Add custom functions directory to fpath and autoload everything in /functions (with silent fail)
fpath+=($ZSH_CUSTOM/functions)
[[ -n "$(ls $ZSH_CUSTOM/functions 2>/dev/null)" ]] && autoload -Uz $ZSH_CUSTOM/functions/*

fpath+=($ZSH_CUSTOM/local-functions)
[[ -n "$(ls $ZSH_CUSTOM/local-functions 2>/dev/null)" ]] && autoload -Uz $ZSH_CUSTOM/local-functions/*

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
