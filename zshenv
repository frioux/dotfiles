setopt extended_glob
for zshrc_snipplet in ~/.zsh/envrc/S[0-9][0-9]*[^~] ; do
        source $zshrc_snipplet
done
