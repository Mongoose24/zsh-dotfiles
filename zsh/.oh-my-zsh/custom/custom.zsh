# custom ZSH stuff goes here i guess

# Welcome fastfetch message
if [ "$(ps -o ppid= -p $$)" != "$(cat /tmp/term_session_ppid 2>/dev/null)" ]; then
    ps -o ppid= -p $$ > /tmp/term_session_ppid
    fastfetch
fi

# Zoxide
eval "$(zoxide init zsh)"

# XTERM-GHOSTTY ONLY History substring search arrow bindings
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# Add custom functions directory to fpath and autoload everything in /functions
fpath+=($ZSH_CUSTOM/functions)
autoload -Uz $ZSH_CUSTOM/functions/*

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
