#!/bin/bash -e

source test/test.bash

PATH=$PWD/bin:$PATH
source bpan :std

ok "`bpan:can use`"         'use is imported'
ok "`bpan:can die`"         'die is imported'
ok "`bpan:can warn`"        'warn is imported'

ok "`! bpan:can import`"    'import is not imported'
ok "`! bpan:can main`"      'main is not imported'
ok "`! bpan:can fcopy`"     'fcopy is not imported'
ok "`! bpan:can findlib`"   'findlib is not imported'
ok "`! bpan:can can`"       'can is not imported'

done_testing 8
