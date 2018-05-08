#!/bin/zsh

# Do not run if we only checked out a file vs switched branches
if [[ -n "$3" && "$3" -eq 0 ]]; then
   exit
fi

echo "running rc installer"

function link-file { mkdir -p "${2:h}"; rm -rf "$2"; ln -s "$PWD/$1" "$2" }
function copy-file { mkdir -p "${2:h}"; rm -rf "$2"; cp "$PWD/$1" "$2" }

./install-xdg

mkdir -p ~/.config

if [[ -e ~/.frewmbot-local ]]; then
   link-file dotjs ~/.js
   link-file ssh/config ~/.ssh/config
   link-file ssh/authorized_keys ~/.ssh/authorized_keys
   link-file terminator_config ~/.config/terminator/config
   link-file xsession ~/.xinitrc
   link-file taffybar/taffybar.hs ~/.config/taffybar/taffybar.hs
   if [ -d "$HOME/var/mail" ]; then
      link-file crontab.d/hourly/notmuch ~/.crontab.d/hourly/notmuch
   else
      rm -f ~/.crontab.d/hourly/notmuch
   fi

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
      dbic.json       \
      dzil            \
      editorconfig    \
      gtkrc-2.0       \
      gtkrc.mine      \
      irssi           \
      jshintrc        \
      mailcap         \
      mutt            \
      muttrc          \
      notmuch-config  \
      offlineimaprc   \
      offlineimap.py  \
      perltidyrc      \
      signature       \
      tmux.conf       \
      XCompose        \
      Xdefaults       \
      xmodmap         \
      xmonad          \
      xscreensaver    \
      xsession        \
      weechat         \
      zr-mutt         \
   ; do
      link-file $x ~/.$x
   done

   test ! -e ~/.tmux/plugins/tpm && \
      git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

   ~/.tmux/plugins/tpm/bin/clean_plugins
   ~/.tmux/plugins/tpm/bin/install_plugins
fi

link-file install.sh .git/hooks/post-checkout
link-file install.sh .git/hooks/post-merge

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

if [[ ! -e ~/.frewmbot-maintained ]]; then
   # bypass git wrapper
   /usr/bin/git clean -xdff
fi

# ensure submodules are checked out before linking to them
if [ ! -e ~/.frewmbot-maintained ]; then
   git submodule update --init --  \
      vim/bundle/FastFold          \
      vim/bundle/airline           \
      vim/bundle/better-whitespace \
      vim/bundle/commentary        \
      vim/bundle/pathogen          \
      vim/bundle/perl              \
      vim/bundle/unimpaired
else
   git submodule update --init
   link-file zsh/cxregs-bash-tools/lib ~/.smartcd/lib
   if [[ ! -e ~/.fzf ]] ; then
      git clone https://github.com/junegunn/fzf.git ~/.fzf
      ~/.fzf/install
   fi
fi

mkdir -p "$HOME/.vvar/undo";
mkdir -p "$HOME/.vvar/swap";
mkdir -p "$HOME/.vvar/sessions";

if test ! -e ~/bin/leatherman || older-than ~/bin/leatherman c 7d; then
   (
      LMURL="$(curl -s https://api.github.com/repos/frioux/leatherman/releases/latest |
         grep browser_download_url |
         cut -d '"' -f 4)"
      mkdir -p ~/bin
      curl -sL "$LMURL" > ~/bin/leatherman.xz
      xz -d ~/bin/leatherman.xz
      chmod +x ~/bin/leatherman
      ~/bin/leatherman explode
   ) &
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
