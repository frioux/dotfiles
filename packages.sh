#!/bin/sh

set -e

./packages.rm.sh
./packages.minimal.sh
./packages.x11.sh
./packages.perf.sh

exec apt-get --no-install-recommends    \
                             install -y \
   at                                   \
   build-essential                      \
   dictd                                \
   dict                                 \
   dict-gcide                           \
   gettext                              \
   gitk                                 \
   inotify-tools                        \
   libcapture-tiny-perl                 \
   libcurl4-openssl-dev                 \
   libdbd-sqlite3-perl                  \
   libdbi-perl                          \
   libdir-self-perl                     \
   libemail-address-perl                \
   libemail-date-perl                   \
   libidn11-dev                         \
   libgmime-2.6-dev                     \
   libgpgme11-dev                       \
   liblmdb-dev                          \
   libncursesw5-dev                     \
   libnotmuch-dev                       \
   libssl-dev                           \
   libtalloc-dev                        \
   libtokyocabinet-dev                  \
   libtool                              \
   libxml2-utils                        \
   libyaml-syck-perl                    \
   lynx                                 \
   manpages-dev                         \
   mitmproxy                            \
   openvpn                              \
   shellcheck                           \
   xsltproc                             \
   fzf                                  \
   uuid-runtime
