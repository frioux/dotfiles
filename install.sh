#!/bin/zsh

echo "running rc installer"

function link-file { __mkdir "${2:h}"; rm -rf "$2"; ln -s "$PWD/$1" "$2" }
function copy-file { __mkdir "${2:h}"; rm -rf "$2"; cp "$PWD/$1" "$2" }

perl install-cronjobs.pl
link-file awesome ~/.config/awesome
link-file dotjs ~/.js
link-file ssh/config ~/.ssh/config
link-file ssh/authorized_keys ~/.ssh/authorized_keys
link-file terminator_config ~/.config/terminator/config
copy-file keepassx_config.ini ~/.config/keepassx/config.ini
link-file install.sh .git/hooks/post-checkout
link-file install.sh .git/hooks/post-merge
link-file xsession ~/.xinitrc
link-file gpg.conf ~/.gnupg/gpg.conf
link-file todo ~/.todo/config
link-file ww-roller.pl/ww_roll.pl ~/bin/ww-roll.pl
source ~/.smartcd/lib/core/arrays
source ~/.smartcd/lib/core/varstash
source ~/.smartcd/lib/core/smartcd
cat smartcd-export | smartcd import

# literal dotfiles
for x in           \
   adenosinerc.yml \
   dbic.json       \
   dzil            \
   gitconfig       \
   gitignore_global\
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
   proverc         \
   signature       \
   tkremindrc      \
   tmux.conf       \
   XCompose        \
   Xdefaults       \
   xmodmap         \
   xscreensaver    \
   xsession        \
   zsh             \
   weechat         \
   zshrc           \
   zshenv          \
   fruperl         \
; do
   link-file $x ~/.$x
done

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
