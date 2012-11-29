autoload -U compinit

zsh_cache=${HOME}/.zsh/cache
mkdir -p $zsh_cache

if [ $UID -eq 0 ]; then
        compinit
else
        compinit -d $zsh_cache/zcomp-$HOST
fi

setopt extended_glob
for zshrc_snipplet in ~/.zsh/rc/S[0-9][0-9]*[^~] ; do
        source $zshrc_snipplet
done

