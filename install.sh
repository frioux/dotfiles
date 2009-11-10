#!/bin/bash

rm ~/.xmonad ~/bin/showdm ~/bin/eval ~/.Xdefaults ~/.vim ~/.zshrc ~/.vimrc\
   ~/.screenrc ~/.irssi -R
ln -s "$(pwd)/zshrc" ~/.zshrc
ln -s "$(pwd)/bin/showdm" ~/bin/showdm
ln -s "$(pwd)/bin/eval" ~/bin/eval
ln -s "$(pwd)/Xdefaults" ~/.Xdefaults
ln -s "$(pwd)/vimrc" ~/.vimrc
ln -s "$(pwd)/screenrc" ~/.screenrc
ln -s "$(pwd)/vim" ~/.vim
ln -s "$(pwd)/irssi" ~/.irssi
ln -s "$(pwd)/xmonad" ~/.xmonad

