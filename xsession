#!/bin/sh

export PATH=/home/frew/code/dotfiles/bin:/home/frew/code/dzen:/home/frew/perl5/perlbrew/bin:/opt/bin:$PATH
export TERM=screen-256color
cd /home/frew/code/dotfiles/bin
dstat --mem --battery --cpu --thermal --output out.csv | ./rrdstore.pl &
status.zsh | dzen2 -bg black -fn terminus -ta r -e ''&
cd /home/frew
urxvt&
xsetroot -solid black&

xmonad
