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
   link-file awesome ~/.config/awesome
   git submodule update --init --  \
      awesome/charitable           \
      awesome/vicious

   link-file ssh/config ~/.ssh/config
   link-file XCompose ~/.XCompose

   if [ -L ~/.ssh/authorized_keys -o ! -e ~/.ssh/authorized_keys ]; then
      link-file ssh/authorized_keys ~/.ssh/authorized_keys
   fi

   link-file terminator_config ~/.config/terminator/config
   link-file xsession ~/.xinitrc

   for x in           \
      curlrc          \
      editorconfig    \
      gtkrc-2.0       \
      gtkrc.mine      \
      mailcap         \
      signature       \
      tmux.conf       \
      Xdefaults       \
      xsession        \
   ; do
      link-file $x ~/.$x
   done
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
fi

mkdir -p "$HOME/.vvar/undo";
mkdir -p "$HOME/.vvar/swap";
mkdir -p "$HOME/.vvar/sessions";

if test ! -e ~/bin/leatherman || older-than ~/bin/leatherman c 7d; then
   bin/install-leatherman &
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
