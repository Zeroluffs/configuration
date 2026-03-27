#!/bin/bash

DOTFILES=~/dotfiles

# clone the repo if it doesn't exist
if [ ! -d "$DOTFILES" ]; then
  git clone https://github.com/you/dotfiles.git $DOTFILES
fi

# copy configs
cp -r $DOTFILES/nvim ~/.config/nvim
cp -r $DOTFILES/wezterm ~/.config/wezterm
cp -r $DOTFILES/tmux ~/.config/tmux
cp $DOTFILES/.zshrc ~/.zshrc

# copy scripts
mkdir -p ~/bin
cp $DOTFILES/bin/* ~/bin/
chmod +x ~/bin/*

echo "done"
