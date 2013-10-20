#!/bin/bash -e

source test/test.bash

PATH=$PWD/bin:$PATH
source bpan :std

ok $? '`source bpan` works'

is "$BPAN_VERSION" '0.0.1' 'BPAN_VERSION is 0.0.1'

done_testing 2
