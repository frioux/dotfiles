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
   gtkrc.mine   \
   gtkrc-2.0    \
   dzil         \
   gitconfig    \
   irssi        \
   tmux.conf    \
   Xdefaults    \
   xsession     \
   zsh          \
   zshrc        \
   dbic.json    \
   perltidyrc   \
; do
   rm -rf "$HOME/.$x";
   ln -s "$(pwd)/$x" "$HOME/.$x";
done

rm -rf "$HOME/.config/awesome";
ln -s "$(pwd)/awesome" "$HOME/.config/awesome";
git submodule update --init --quiet
rm -f "$HOME/bin/spark"
ln -s "$(pwd)/zsh/spark/spark" "$HOME/bin/spark"

mkdir -p "$HOME/.smartcd"
rm -rf "$HOME/.smartcd/lib"
ln -s "$(pwd)/zsh/cxregs-bash-tools/lib" "$HOME/.smartcd/lib"
mkdir -p "$HOME/lib"
rm -rf "$HOME/lib/resty"
ln -s "$(pwd)/zsh/resty" "$HOME/lib/resty"
rm -rf "$HOME/lib/zaw"
ln -s "$(pwd)/zsh/zaw" "$HOME/lib/zaw"
rm -rf "$HOME/.js"
ln -s "$(pwd)/dotjs" "$HOME/.js"

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
