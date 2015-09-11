#!/bin/dash

./packages.x11.sh
./packages.perf.sh

apt-get --no-install-recommends install \
   aptitude                             \
   asciidoc                             \
   autoconf                             \
   automake                             \
   build-essential                      \
   curl                                 \
   daemontools                          \
   fail2ban                             \
   gnupg-agent                          \
   htop                                 \
   inotify-tools                        \
   libcurl4-openssl-dev                 \
   libdir-self-perl                     \
   libgmime-2.6-dev                     \
   libgpgme11-dev                       \
   libncursesw5-dev                     \
   libnotmuch-dev                       \
   libpam0g-dev                         \
   libtalloc-dev                        \
   libtokyocabinet-dev                  \
   libtool                              \
   libxapian-dev                        \
   lua-filesystem                       \
   lynx                                 \
   mitmproxy                            \
   moreutils                            \
   mosh                                 \
   msmtp                                \
   notmuch                              \
   notmuch-mutt                         \
   openssh-client                       \
   openssh-server                       \
   openvpn                              \
   pv                                   \
   python-gpgme                         \
   tmux                                 \
   tree                                 \
   unattended-upgrades                  \
   vim                                  \
   xmlto                                \
   xsltproc                             \
   zsh
