#!/bin/sh

sudo snap install keepassxc

exec apt-get --no-install-recommends    \
                             install -y \
   feh                                  \
   firefox                              \
   fonts-lohit-knda                     \
   gnome-system-monitor                 \
   gnome-power-manager                  \
   gksu                                 \
   gtk2-engines                         \
   gxmessage                            \
   i3lock                               \
   pavucontrol                          \
   pcmanfm                              \
   rdesktop                             \
   suckless-tools                       \
   taffybar                             \
   tcl                                  \
   terminator                           \
   tk                                   \
   tk8.5                                \
   ttf-ancient-fonts                    \
   vim-gnome                            \
   vim-gtk                              \
   vlc                                  \
   xautolock                            \
   xbacklight                           \
   xcalib                               \
   xdotool                              \
   xfonts-terminus                      \
   xfonts-terminus-oblique              \
   xsel                                 \
   xmonad
