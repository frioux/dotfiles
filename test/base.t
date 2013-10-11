#!/bin/bash

set -e

echo '1..2'

{
    PATH=$PWD/bin:$PATH source bpan
    echo 'ok 1 - Source BPAN works'
}

label='BPAN_VERSION is 0.0.1'
if [ $BPAN_VERSION == '0.0.1' ]; then
    echo "ok 2 - $label"
else
    echo "not ok 2 - $label"
fi
