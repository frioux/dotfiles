#!/bin/bash -e

source test/test.bash

plan 2

PATH=$PWD/bin:$PATH source bpan
ok $? 'Source BPAN works'

is "$BPAN_VERSION" '0.0.1' 'BPAN_VERSION is 0.0.1'


