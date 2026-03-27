# configuration

My personal dotfiles for nvim, wezterm, tmux and shell scripts.

## Structure

​```
dotfiles/
  nvim/
  wezterm/
  tmux/
  bin/
  .zshrc
​```

## Install on a new machine

​```bash
bash <(curl -s https://raw.githubusercontent.com/Zeroluffs/configuration/main/bin/dotfiles-install.sh)
​```

This will:
- Clone the repo into `~/dotfiles`
- Symlink all configs to their correct locations
- Symlink all scripts into `~/bin`

## Updating configs

Since configs are symlinked, just edit them as normal then:

​```bash
cd ~/dotfiles
git add/commit/push
​```

## Syncing to another machine

​```bash
cd ~/dotfiles && git pull
​```

## Alias

Add this to your `.zshrc` to use the `dots` command:

​```bash
alias dots=~/bin/dotfiles.sh
​```
