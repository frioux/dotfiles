#!/bin/sh

apt-get build-dep neomutt

exec apt-get --no-install-recommends    \
                             install -y \
   aptitude                             \
   curl                                 \
   daemontools                          \
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
