#!/bin/sh

sudo snap install keepassxc

exec apt-get --no-install-recommends    \
                             install -y \
   rofi                                 \
   feh                                  \
   firefox                              \
   fonts-lohit-knda                     \
   gcalcli                              \
   gnome-system-monitor                 \
   gnome-power-manager                  \
   gtk2-engines                         \
   i3lock                               \
   libfile-readbackward-perl            \
   libio-all-perl                       \
   pavucontrol                          \
   pcmanfm                              \
   flameshot                            \
   suckless-tools                       \
   terminator                           \
   ttf-ancient-fonts                    \
   vim-gtk                              \
   vlc                                  \
   xautolock                            \
   xbacklight                           \
   xcalib                               \
   xclip                                \
   xdotool                              \
   xfonts-terminus                      \
   xfonts-terminus-oblique              \
   xsel                                 \
   xinput
