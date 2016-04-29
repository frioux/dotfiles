autoload -U compinit

zsh_cache=${HOME}/.zsh/cache
mkdir -p $zsh_cache

fpath=(~/code/dotfiles/git-hub/share/zsh-completion $fpath)
if [ $UID -eq 0 ]; then
        compinit
else
        compinit -d $zsh_cache/zcomp-$HOST
fi

setopt extended_glob
for zshrc_snipplet in ~/.zsh/rc/S[0-9][0-9]*[^~] ; do
        source $zshrc_snipplet
done

