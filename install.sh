#!/bin/zsh

function _mkdir {
   if [[ ! -d $1 ]]; then
      mkdir -p $1
   fi
}

function link-file {
   _mkdir "${2:h}"
   rm -rf "$2"
   echo "linking $PWD/$1 $2"
   ln -s "$PWD/$1" "$2"
}

function dotlink-file {
   link-file $1 "$HOME/.$1"
}

link-file terminator_config ~/.config/terminator

for x in        \
   gtkrc.mine   \
   gtkrc-2.0    \
   dzil         \
   gitconfig    \
   irssi        \
   tmux.conf    \
   Xdefaults    \
   xsession     \
   mutt         \
   msmtprc      \
   muttrc       \
   zsh          \
   signature    \
   offlineimaprc\
   zshrc        \
   dbic.json    \
   adenosinerc.yml \
   perltidyrc   \
   jshintrc     \
; do
   dotlink-file $x
done

link-file awesome ~/.config/awesome
git submodule update --init --quiet
link-file zsh/spark/spark ~/bin/spark

link-file zsh/cxregs-bash-tools/lib ~/.smartcd
link-file zsh/zaw ~/lib/zaw
link-file dotjs ~/.js
link-file ssh_config ~/.ssh/config

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

pushd bin
for tool in *; do
   link-file $tool ~/bin/$tool
done
popd

link-file install.sh .git/hooks/post-checkout
link-file install.sh .git/hooks/post-merge
