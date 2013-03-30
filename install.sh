#!/bin/zsh

function _mkdir { if [[ ! -d $1 ]]; then mkdir -p $1; fi }
function link-file { _mkdir "${2:h}"; rm -rf "$2"; ln -s "$PWD/$1" "$2" }
function copy-file { _mkdir "${2:h}"; rm -rf "$2"; cp "$PWD/$1" "$2" }

link-file awesome ~/.config/awesome
link-file dotjs ~/.js
link-file ssh/config ~/.ssh/config
link-file ssh/authorized_keys ~/.ssh/authorized_keys
link-file terminator_config ~/.config/terminator/config
copy-file keepassx_config.ini ~/.config/keepassx/config.ini
link-file install.sh .git/hooks/post-checkout
link-file install.sh .git/hooks/post-merge
link-file xsession ~/.xinitrc

# literal dotfiles
for x in           \
   adenosinerc.yml \
   dbic.json       \
   dzil            \
   gitconfig       \
   gtkrc-2.0       \
   gtkrc.mine      \
   irssi           \
   jshintrc        \
   msmtprc         \
   mailcap         \
   mutt            \
   muttrc          \
   notmuch-config  \
   offlineimaprc   \
   offlineimap.py  \
   perltidyrc      \
   signature       \
   tmux.conf       \
   Xdefaults       \
   xmodmap         \
   xscreensaver    \
   xsession        \
   zsh             \
   weechat         \
   zshrc           \
   fruperl         \
; do
   link-file $x ~/.$x
done

# executables
pushd bin
for tool in *; do
   link-file $tool ~/bin/$tool
done
popd

# vim works differently on win32
case $OSTYPE in
   cygwin)
      home="$(cygpath $USERPROFILE)";
      rm -rf "$home/_vimrc";
      cp vimrc "$home/_vimrc";
      rm -rf "$home/.vim";
      cp -r vim "$home/.vim";
      mkdir -p "$home/var/undo";
      mkdir -p "$home/var/swap";
   ;;
   *)
      link-file vimrc ~/.vimrc
      link-file vim ~/.vim
   ;;
esac

# ensure submodules are checked out before linking to them
git submodule update --init --quiet
link-file zsh/cxregs-bash-tools/lib ~/.smartcd/lib
link-file zsh/zaw ~/lib/zaw
pkill -usr1 zsh
