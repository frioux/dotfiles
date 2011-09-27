#!/bin/zsh

if [[ ! -x ~/bin ]]; then
   mkdir ~/bin
fi

if [[ ! -x ~/.config/terminator ]]; then
   mkdir -p ~/.config/terminator
fi

rm ~/.xmonad ~/bin/showdm ~/bin/eval ~/.Xdefaults ~/.vim ~/.zshrc ~/.vimrc\
   ~/.screenrc ~/.irssi ~/.gitconfig ~/.config/terminator/config\
   ~/passwords.kdb ~/.xsession ~/bin/wrap-git ~/.pentadactylrc ~/.zsh \
   ~/.emacs ~/.tmux.conf ~/.dzil ~/bin/git-amend-file-split -Rf

ln -s "$(pwd)/bin/eval" ~/bin/eval
ln -s "$(pwd)/bin/showdm" ~/bin/showdm
ln -s "$(pwd)/bin/wrap-git" ~/bin/wrap-git
ln -s "$(pwd)/bin/git-amend-file-split" ~/bin/git-amend-file-split
ln -s "$(pwd)/irssi" ~/.irssi
ln -s "$(pwd)/gitconfig" ~/.gitconfig
ln -s "$(pwd)/screenrc" ~/.screenrc
ln -s "$(pwd)/terminator_config" ~/.config/terminator/config
ln -s "$(pwd)/vimrc" ~/.vimrc
ln -s "$(pwd)/vim" ~/.vim
ln -s "$(pwd)/Xdefaults" ~/.Xdefaults
ln -s "$(pwd)/xmonad" ~/.xmonad
ln -s "$(pwd)/zshrc" ~/.zshrc
ln -s "$(pwd)/zsh" ~/.zsh
ln -s "$(pwd)/passwords.kdb" ~/passwords.kdb
ln -s "$(pwd)/xsession" ~/.xsession
ln -s "$(pwd)/emacs" ~/.emacs
ln -s "$(pwd)/pentadactylrc" ~/.pentadactylrc
ln -s "$(pwd)/tmux.conf" ~/.tmux.conf
ln -s "$(pwd)/dzil" ~/.dzil

