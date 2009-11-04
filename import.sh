#!/bin/bash

cp ~/.zshrc zshrc
cp ~/.vimrc vimrc
cp ~/.Xdefaults Xdefaults
cp ~/.screenrc screenrc
rm -r vim
cp ~/.vim vim -R
rm -r irssi
cp ~/.irssi irssi -R
cp ~/.xmonad xmonad -R

