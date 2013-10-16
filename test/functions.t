#!/bin/bash -e

source test/test.bash
PATH=$PWD/bin:$PATH source bpan

functions=(
    main import fcopy include includable
    die warn prompt out out- err err-
)

plan 12


for f in ${functions[@]}; do
  is "$(type -t "bpan:$f")" function \
    "main:$f is a function"
done

# vim: set sw=2:
