alias make="make -j`nproc`"
alias ninja="ninja -j`nproc`"
alias n="nano"
# alias n="ninja"
alias c="clear"
alias x="exit"
alias rmpkg="sudo pacman -Rsn"
alias cleanch="sudo pacman -Scc"
alias fixpacman='sudo rm /var/lib/pacman/db.lck'
alias update='sudo pacman -Syu'
alias ssh="env TERM=xterm-256color ssh"

# Help people new to Arch
alias tb="nc termbin.com 9999"

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rsn $(pacman -Qtdq)'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# Navigation
alias up="cd .."
alias find="fd"
alias grep="rg"
alias cd="z"
alias zshrc="nano ~/dotfiles/zsh/.zshrc"
alias custom="nano ~/dotfiles/zsh/.oh-my-zsh/custom/custom.zsh"
alias aliases="nano ~/dotfiles/zsh/.oh-my-zsh/custom/aliases.zsh"
alias laliases="nano ~/dotfiles/zsh/.oh-my-zsh/custom/local-functions/local-aliases"
alias lfuncs="cd ~/dotfiles/zsh/.oh-my-zsh/custom/local-functions"
alias funcs="cd ~/dotfiles/zsh/.oh-my-zsh/custom/functions"
alias dot="cd ~/dotfiles"
alias sshconf="nano ~/.ssh/config"
alias szs='source ~/.zshrc'

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


# LD-CachyOS Specific
alias windowsc="sudo mount /dev/nvme0n1p3 /mnt/windows"
alias windowscu="sudo umount /mnt/windows"
alias kitty-config="nano ~/.config/kitty/current-theme.conf"
alias ghostty-config="nano ~/.config/ghostty/config"
