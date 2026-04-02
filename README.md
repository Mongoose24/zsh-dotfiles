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

`custom.zsh` is where custom stuff goes (like env vars, adding things to path, etc.)

`functions` (directory) has some pre-made functions I use all the time for yazi and fzf.
 - 

## Keybinds/functions

Peak through `local-zsh.zsh` (type `lzsh` to quick open it). This is where you will add/change any custom aliases you would like. I keep all aliases and local machine related stuff here. 

`custom.zsh` is where any extra zsh specific stuff or env vars go (`custom` to quick open it). Everything here gets sourced in zshrc.

`functions` already has a `dotpull` function created to repull dotfiles if there are changes, but make sure to back up any custom stuff you have added and merge after pulling again. (type `funcs` to cd into functions directory) I already have a fzf and yazi wrapper function here to add some functionality to fzf and yazi. Type `f` for fzf, and `y` for yazi. Once in fzf, `alt+n` will nano whatever file you have selected. `enter` will bring you to whatever directory its in. For yazi, `n` will open the file in nano, `o` will open the file selected in  Everything here gets sourced in zshrc. 

`local-functions` is where custom machine specific functions are placed, go wild. Type `lfuncs` to cd into local-functions dir. Everything here will get sourced in zshrc
