#!/bin/zsh

set -e

# Do not run if we only checked out a file vs switched branches
if [[ -n "$3" && "$3" -eq 0 ]]; then
   exit
fi

echo "running rc installer"

function link-file { mkdir -p "${2:h}"; rm -rf "$2"; ln -s "$PWD/$1" "$2" }
function copy-file { mkdir -p "${2:h}"; rm -rf "$2"; cp "$PWD/$1" "$2" }

./install-xdg

mkdir -p ~/.config

if [ -e ~/.frewmbot-local ]; then
   link-file dotjs ~/.js
   link-file ssh/config ~/.ssh/config
   link-file XCompose ~/.XCompose

   if [ -L ~/.ssh/authorized_keys -o ! -e ~/.ssh/authorized_keys ]; then
      link-file ssh/authorized_keys ~/.ssh/authorized_keys
   fi

   link-file terminator_config ~/.config/terminator/config
   link-file xsession ~/.xinitrc
   link-file crontab.d/hourly/gcal ~/.crontab.d/hourly/gcal

   if [ -f "$HOME/.goobook_auth.json" -o -d "$HOME/var/mail" ]; then
      link-file bin/sync-addresses ~/.crontab.d/hourly/sync-addresses
   else
      rm -f ~/.crontab.d/hourly/sync-addresses
   fi
   mkdir -p ~/.crontab.d/minutely ~/.crontab.d/hourly
   crontab="$(tempfile)"
   if [ $(ls "$HOME/.crontab.d/hourly" | wc -l) -gt 0 ]; then
      echo '3 * * * * . "$HOME/.env" && run-parts "$HOME/.crontab.d/hourly"' >> $crontab
   fi

   if [ $(ls "$HOME/.crontab.d/minutely" | wc -l) -gt 0 ]; then
      echo '* * * * * . "$HOME/.env" && run-parts "$HOME/.crontab.d/minutely"' >> $crontab
   fi
   crontab "$crontab"

   for x in           \
      adenosinerc.yml \
      curlrc          \
      dbic.json       \
      dzil            \
      editorconfig    \
      gtkrc-2.0       \
      gtkrc.mine      \
      irssi           \
      jshintrc        \
      mailcap         \
      perltidyrc      \
      signature       \
      tmux.conf       \
      Xdefaults       \
      xmodmap         \
      xmonad          \
      xscreensaver    \
      xsession        \
      weechat         \
   ; do
      link-file $x ~/.$x
   done
fi

link-file install.sh .git/hooks/post-checkout
link-file install.sh .git/hooks/post-merge
link-file awesome ~/.config/awesome

for x in           \
   env             \
   gitconfig       \
   gitignore_global\
   zsh             \
   zshrc           \
   zshenv          \
; do
   link-file $x ~/.$x
done

echo "[submodule]\n\tfetchJobs = $(nproc)\n\n" > ~/.git-multicore

if [ ! -e ~/.frewmbot-maintained ]; then
   # bypass git wrapper
   /usr/bin/git clean -xdff
fi

# ensure submodules are checked out before linking to them
if [ ! -e ~/.frewmbot-maintained ]; then
   git submodule update --init --  \
      vim/pack/vanilla/start/FastFold          \
      vim/pack/vanilla/start/airline           \
      vim/pack/vanilla/start/better-whitespace \
      vim/pack/vanilla/start/commentary        \
      vim/pack/vanilla/opt/pathogen            \
      vim/pack/vanilla/start/perl              \
      vim/pack/vanilla/start/unimpaired
else
   git submodule update --init
   if [[ ! -e ~/.fzf ]] ; then
      git clone https://github.com/junegunn/fzf.git ~/.fzf
      ~/.fzf/install
   fi
fi

mkdir -p "$HOME/.vvar/undo";
mkdir -p "$HOME/.vvar/swap";
mkdir -p "$HOME/.vvar/sessions";

if test ! -e ~/bin/leatherman || older-than ~/bin/leatherman c 7d; then
   install-leatherman &
fi

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
      link-file gvimrc ~/.gvimrc
      link-file vim ~/.vim
      link-file vim ~/.config/nvim
   ;;
esac
