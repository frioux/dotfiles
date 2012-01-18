#!/bin/zsh

if [[ ! -x ~/bin ]]; then
   mkdir ~/bin
fi

if [[ ! -x ~/.config/terminator ]]; then
   mkdir -p ~/.config/terminator
fi
rm ~/.config/terminator/config
ln -s "$(pwd)/terminator_config" ~/.config/terminator/config
rm ~/passwords.kdb
ln -s "$(pwd)/passwords.kdb" ~/passwords.kdb

for x in        \
   dzil         \
   gitconfig    \
   irssi        \
   screenrc     \
   tmux.conf    \
   Xdefaults    \
   xmonad       \
   xsession     \
   zsh          \
   zshrc        \
; do
   rm -rf "$HOME/.$x";
   ln -s "$(pwd)/$x" "$HOME/.$x";
done

case $OSTYPE in
   cygwin)
      rm -rf "$(cygpath $USERPROFILE)/_vimrc";
      cp vimrc "$(cygpath $USERPROFILE)/_vimrc";
      rm -rf "$(cygpath $USERPROFILE)/.vim";
      cp -r vim "$(cygpath $USERPROFILE)/.vim";

   ;;
   *)
      rm -rf "$HOME/.vimrc";
      ln -s "$(pwd)/vimrc" "$HOME/.vimrc";
      rm -rf "$HOME/.vim";
      ln -s "$(pwd)/vim" "$HOME/.vim";
   ;;
esac

pushd bin;
for tool in *; do
   rm "$HOME/bin/$tool"
   ln -s "$(pwd)/$tool" "$HOME/bin/$tool"
done
popd;

