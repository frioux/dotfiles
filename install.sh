#!/bin/zsh

if [[ ! -x ~/bin ]]; then
   mkdir ~/bin
fi

if [[ ! -x ~/.config/terminator ]]; then
   mkdir -p ~/.config/terminator
fi
rm -f ~/.config/terminator/config
ln -s "$(pwd)/terminator_config" ~/.config/terminator/config
rm -f ~/passwords.kdb
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

rm -f "$HOME/bin/spark"
ln -s "$(pwd)/zsh/spark/spark" "$HOME/bin/spark"

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
      rm -rf "$HOME/.vimrc";
      ln -s "$(pwd)/vimrc" "$HOME/.vimrc";
      rm -rf "$HOME/.vim";
      ln -s "$(pwd)/vim" "$HOME/.vim";
   ;;
esac

pushd bin;
for tool in *; do
   rm -f "$HOME/bin/$tool"
   ln -s "$(pwd)/$tool" "$HOME/bin/$tool"
done
popd;

rm -f .git/hooks/post-checkout
rm -f .git/hooks/post-merge
ln -s "$(pwd)/install.sh" .git/hooks/post-checkout
ln -s "$(pwd)/install.sh" .git/hooks/post-merge
