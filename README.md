## Installation
1. Clone dotfiles repo
```
git clone https://github.com/Mongoose24/dotfiles.git ~/dotfiles 
```

2. cd into dotfiles
```
cd ~/dotfiles
```

3. chmod script(s)
```
chmod +x deb-in.sh
```
or
```
chmod +x arch-in.sh
```

4. check script contents if you want, then run it
```
./deb-in.sh
```
or
```
./arch-in.sh
```

5. Enjoy dotfiles.

## File Structure (IMPORTANT)
`local-zsh.zsh` is where you will add/change any custom aliases or local zsh related stuff. Keep `zshrc` clean and simple and toss all aliases here. 

`aliases.zsh` is where MY aliases go (its best if you add your own alaises to `local-zsh.zsh` to keep things seperate, but peak through here and get to know some of the simple stuff- like `ll` `la` `x` `c` `up` etc. Feel free to remove anything you want- this is just what I use across all machines.)

`custom.zsh` is where custom stuff goes (like env vars, adding things to path, etc.)

`/functions` has some pre-made functions I use all the time for yazi and fzf (see keybind section below for explinations- also anything here automatically gets plugged in via zshrc)

`/local-functions` is where any custom or machine specific functions go. go wild with it. (anything here automatically gets plugged in via zshrc)

## Keybinds/functions
`zoxide` always use `z` instead of `cd`, will learn your directory layout and makes cd-ing around super easy and fast.

`/functions`: quick open with `funcs` alias

`dotpull` pulls latest from this repo, but DON'T FORGET TO BACKUP/MERGE ANYTHING YOU'VE CHANGED FIRST!! (you probably never need to use this, it's more for me when I create new LXC/VMs on my servers and want my dotfiles in a new instance)

fzf (`f`) launches fzf with preview (supports images and svg files)
while in fzf, `alt+n` will nano any file you have selected. press `enter` on any file to cd into the directory its in

yazi (`y`) launches yazi- 
`n` will nano any file selected
`o` will open any file selected in native text editor (like Kwrite/VScode/Kate/etc or whatever you use)
`p` will open any file selected in native file explorer (like dolphin/finder/etc or whatever you use)

`/local-functions`: quick open with `lfuncs`
Comes empty, add whatever you want- pulling from this repo again does not touch that directory (same with local-zsh)
Peak through `local-zsh` (`lzsh` to quick open it) and 


