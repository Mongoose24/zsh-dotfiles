alias make="make -j`nproc`"
alias n="nano"
alias c="clear"
alias x="exit"
alias ssh="env TERM=xterm-256color ssh"
alias up="cd .."
alias zshrc="nano ~/.zshrc"
alias custom="nano ~/.oh-my-zsh/custom/custom.zsh"
alias al="nano ~/.oh-my-zsh/custom/aliases.zsh"
alias lzsh="nano ~/.oh-my-zsh/custom/local-functions/local-zsh.zsh"
alias lfuncs="cd ~/.oh-my-zsh/custom/local-functions"
alias funcs="cd ~/dotfiles/zsh/.oh-my-zsh/custom/functions"
alias dot="cd ~/dotfiles"
alias sshconf="nano ~/.ssh/config"
alias szs='source ~/.zshrc'
alias lgit='lazygit'

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# PACMAN / BREW SEPERATION
if command -v pacman &>/dev/null; then
    alias cleanup='sudo pacman -Rsn $(pacman -Qtdq)'
    alias update='paru -Syu'
    alias rmpkg="sudo pacman -Rsn"
    alias fixpacman='sudo rm /var/lib/pacman/db.lck'
elif command -v brew &>/dev/null; then
    alias cleanup='brew autoremove && brew cleanup'
    alias update='brew update && brew upgrade'
    alias rmpkg="brew uninstall"
fi

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Navigation
# cd with zoxide fallback
if command -v zoxide &>/dev/null; then
    alias cd="z"
fi

# find with fd fallback
if command -v fd &>/dev/null; then
    alias find="fd"
fi

# ll and la with fallbacks
if command -v eza &>/dev/null; then
    alias ll="eza -l --color=always --group-directories-first --icons"
    alias la="eza -la --color=always --group-directories-first --icons"
else
    alias ll="ls -l --color=always --group-directories-first"
    alias la="ls -la --color=always --group-directories-first"
fi

# Sensors / Monitoring
alias nvidia="watch -n 1 nvidia-smi"

# Ghostty config
alias ghostty-config="nano ~/.config/ghostty/config"
