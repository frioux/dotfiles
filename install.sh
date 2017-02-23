#!/bin/zsh

# Do not run if we only checked out a file vs switched branches
if [[ -n "$3" && "$3" -eq 0 ]]; then
   exit
fi

echo "running rc installer"

function __mkdir { if [[ ! -d $1 ]]; then mkdir -p $1; fi }
function link-file { __mkdir "${2:h}"; rm -rf "$2"; ln -s "$PWD/$1" "$2" }
function copy-file { __mkdir "${2:h}"; rm -rf "$2"; cp "$PWD/$1" "$2" }

./install-xdg

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
link-file ww-roller.pl/ww_roll.pl ~/bin/ww-roll.pl

if [ -d "$HOME/var/mail" ]; then
   link-file crontab.d/hourly/notmuch ~/.crontab.d/hourly/notmuch
else
   rm ~/.crontab.d/hourly/notmuch
fi

if [ -f "$HOME/.goobook_auth.json" -o -d "$HOME/var/mail" ]; then
   link-file bin/sync-addresses ~/.crontab.d/hourly/sync-addresses
else
   rm ~/.crontab.d/hourly/sync-addresses
fi
mkdir -p ~/.crontab.d/minutely
link-file env ~/.env

crontab="$(tempfile)"
if [ $(ls "$HOME/.crontab.d/hourly" | wc -l) -gt 0 ]; then
   echo '3 * * * * . "$HOME/.env" && run-parts "$HOME/.crontab.d/hourly"' >> $crontab
fi

if [ $(ls "$HOME/.crontab.d/minutely" | wc -l) -gt 0 ]; then
   echo '* * * * * . "$HOME/.env" && run-parts "$HOME/.crontab.d/minutely"' >> $crontab
fi
crontab "$crontab"

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
   vimoutlinerrc   \
   XCompose        \
   Xdefaults       \
   xmodmap         \
   xscreensaver    \
   xsession        \
   zsh             \
   weechat         \
   zr-mutt         \
   zshrc           \
   zshenv          \
; do
   link-file $x ~/.$x
done

echo "[submodule]\n\tfetchJobs = $(cat /proc/cpuinfo | grep '^processor' | wc -l)\n\n" > ~/.git-multicore

# ensure submodules are checked out before linking to them
git submodule update --init

link-file zsh/cxregs-bash-tools/lib ~/.smartcd/lib
source ~/.smartcd/lib/core/arrays
source ~/.smartcd/lib/core/varstash
source ~/.smartcd/lib/core/smartcd
cat smartcd-export | smartcd import

mkdir -p "$HOME/.vvar/undo";
mkdir -p "$HOME/.vvar/swap";
mkdir -p "$HOME/.vvar/sessions";

# vim works differently on win32
case $OSTYPE in
   cygwin)
      home="$(cygpath $USERPROFILE)";
      rm -rf "$home/_vimrc";
      cp vimrc "$home/_vimrc";
      rm -rf "$home/.vim";
      cp -r vim "$home/.vim";
   ;;
   *)
      link-file vimrc ~/.vimrc
      link-file vim ~/.vim
      rsync -ar services/frew/ ~/services
   ;;
esac
