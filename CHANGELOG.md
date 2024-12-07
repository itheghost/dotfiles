# CHANGELOG
All changes made to any files will be written in here with the date the changes are made

## CLI Tools
### 07.12.2024

\+ Installed fzf, fd, bat, eza, thefuck.

\+ Made a zsh folder to store and moved **.zshrc** to there.

* Created different config files for fzf and aliases:
    * In **fzf.sh** configued fzf with fd, bat and eza.
        * Set up the fzf keybinds
        * Made fzf use fd to find files
        * Made fzf use bat for file previews and use eza for file listings
    * In **alias.sh**
        * Changed ls to eza to have more color and icons
* Removed `Alt-c` and `Alt-v` from **rc.lua**

