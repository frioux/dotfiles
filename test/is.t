#!/usr/bin/env bash

PATH="$(IFS=':';set -- $PWD/ext/*/{bin,lib};echo "$*"):$PATH"
source bpan
bpan:include 'test/more'

plan tests 2

is foo foo 'foo is foo'
ok true 'true is true'
