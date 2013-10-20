#!/bin/bash -e

source test/test.bash

PATH=$PWD/bin:$PATH
source bpan

functions=(
    use
    import
    fcopy
    findlib
    die
    warn
    can
)

for f in ${functions[@]}; do
  is "$(type -t "bpan:$f")" function \
    "bpan:$f is a function"
done

done_testing 7
