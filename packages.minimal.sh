#!/bin/sh

exec apt-get --no-install-recommends    \
                             install -y \
   aptitude                             \
   curl                                 \
   daemontools                          \
   gettext                              \
   fail2ban                             \
   htop                                 \
   jq                                   \
   liblmdb-dev                          \
   libssl-dev                           \
   moreutils                            \
   mosh                                 \
   openssh-client                       \
   openssh-server                       \
   rsync                                \
   pv                                   \
   tmux                                 \
   tree                                 \
   unattended-upgrades                  \
   vim                                  \
   zsh

