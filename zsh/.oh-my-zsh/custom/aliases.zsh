alias make="make -j`nproc`"
alias n="nano"
alias m="micro"
alias sn="sudo nano"
alias sm="sudo micro"
alias c="clear"
alias x="exit"
alias ssh="env TERM=xterm-256color ssh"
alias up="cd .."
alias zshrc="nano ~/.zshrc"
alias custom="nano ~/.oh-my-zsh/custom/custom.zsh"
alias al="nano ~/.oh-my-zsh/custom/aliases.zsh"
alias lzsh="nano ~/.oh-my-zsh/custom/local-functions/local-zsh.zsh"
alias lfuncs="cd ~/.oh-my-zsh/custom/local-functions && ll"
alias funcs="cd ~/dotfiles/zsh/.oh-my-zsh/custom/functions && ll"
alias dot="cd ~/dotfiles && ll"
alias sshconf="nano ~/.ssh/config"
alias szs='source ~/.zshrc'
alias lgit='lazygit'
alias duno='dust --no-percent-bars'
alias lsblko='sudo lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS'

# Error output options
alias -g NE='2>/dev/null'
alias -g DN='> dev/null'
alias -g NUL='/dev/null 2>&1'

# Other global aliases
alias -g JQ='| jq'
alias -g C='| pbcopy'

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# PACMAN / BREW SEPERATION
if command -v pacman &>/dev/null; then
    alias cleanup='paru -Rsn $(pacman -Qtdq)'
    alias update='paru -Syu'
    alias rmpkg="paru -Rsn"
    alias fixpacman='sudo rm /var/lib/pacman/db.lck'
elif command -v brew &>/dev/null; then
    alias cleanup='brew autoremove && brew cleanup'
    alias update='brew update && brew upgrade'
    alias rmpkg="brew uninstall"
fi

# rsync -> rsyncy/rsync --info-progress2
if command -v rsyncy &>/dev/null; then
    alias rsync='rsyncy'
else
    alias rsync='/usr/bin/rsync --info=progress2'
fi

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

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
