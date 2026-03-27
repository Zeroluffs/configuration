#!/bin/bash

DOTFILES=~/dotfiles

# clone the repo if it doesn't exist
if [ ! -d "$DOTFILES" ]; then
  git clone https://github.com/Zeroluffs/configuration.git $DOTFILES
else
  echo "repo already exists, pulling latest..."
  cd $DOTFILES && git pull
fi

# create config dir if it doesn't exist
mkdir -p ~/.config

# remove existing configs before symlinking
rm -rf ~/.config/nvim
rm -rf ~/.config/wezterm
rm -rf ~/.config/tmux
rm -f ~/.zshrc

# symlink configs
ln -sf $DOTFILES/nvim ~/.config/nvim
ln -sf $DOTFILES/wezterm ~/.config/wezterm
ln -sf $DOTFILES/tmux ~/.config/tmux
ln -sf $DOTFILES/.zshrc ~/.zshrc

# symlink scripts
mkdir -p ~/bin
for script in $DOTFILES/bin/*; do
  ln -sf $script ~/bin/$(basename $script)
done

chmod +x ~/bin/*

echo "done"
```

The `rm -rf` before each symlink is important — `ln -sf` won't overwrite an existing directory, only files, so you need to remove them first or you'll get an error.

Workflow on any machine becomes:
```
edit configs as normal
cd ~/dotfiles
git add/commit/push
```

And on other machines just:
```
cd ~/dotfiles && git pull
