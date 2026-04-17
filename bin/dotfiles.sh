#!/bin/bash

DOTFILES=~/dotfiles

# copy configs
cp -r ~/.config/nvim $DOTFILES
cp -r ~/.config/LazyVim $DOTFILES
cp -r ~/.config/wezterm $DOTFILES
cp -r ~/.config/tmux $DOTFILES
cp -r ~/bin $DOTFILES/bin

cd $DOTFILES

# commit per tool if changed
for dir in nvim LazyVim wezterm tmux; do
  if ! git diff --quiet $dir || git ls-files --others --exclude-standard $dir | grep -q .; then
    git add $dir/
    git commit -m "$dir: update config"
  fi
done

# bin/scripts
if ! git diff --quiet bin || git ls-files --others --exclude-standard bin | grep -q .; then
  git add bin/
  git commit -m "bin: update scripts"
fi

git push
