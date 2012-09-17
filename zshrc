autoload -U compinit zrecompile

zsh_cache=${HOME}/.zsh/cache
mkdir -p $zsh_cache

if [ $UID -eq 0 ]; then
        compinit
else
        compinit -d $zsh_cache/zcomp-$HOST

        for f in ~/.zshrc $zsh_cache/zcomp-$HOST; do
                zrecompile -p $f && rm -f $f.zwc.old
        done
fi

setopt extended_glob
for zshrc_snipplet in ~/.zsh/rc/S[0-9][0-9]*[^~] ; do
        source $zshrc_snipplet
done

