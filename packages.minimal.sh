#!/bin/sh

exec apt-get --no-install-recommends    \
                             install -y \
   aptitude                             \
   curl                                 \
   daemontools                          \
   fzf                                  \
   htop                                 \
   jq                                   \
   moreutils                            \
   mosh                                 \
   openssh-client                       \
   openssh-server                       \
   ripgrep                              \
   rsync                                \
   pv                                   \
   tmux                                 \
   tree                                 \
   unattended-upgrades                  \
   vim                                  \
   zsh
