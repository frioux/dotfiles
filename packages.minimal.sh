#!/bin/dash

exec apt-get --no-install-recommends    \
                             install -y \
   aptitude                             \
   curl                                 \
   daemontools                          \
   fail2ban                             \
   htop                                 \
   liblmdb-dev                          \
   moreutils                            \
   mosh                                 \
   openssh-client                       \
   openssh-server                       \
   pv                                   \
   tmux                                 \
   tree                                 \
   unattended-upgrades                  \
   vim                                  \
   zsh

