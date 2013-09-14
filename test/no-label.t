#!/bin/bash

PATH=lib:$PATH
source test-simple.bash tests 14

ok 0
ok $((6 * 7 -42))
ok true
ok $(false || true; echo $?)

ls &> /dev/null
ok $?
ls --qqq &> /dev/null
ok $((! $?))

fruit=apple

ok [ $fruit = apple ]
ok [ "0" == "0" -a 1 -eq 1 ]
ok [ ${fruit/a/A} = Apple ]
ok [ "${fruit}s" = 'app''les' ]
ok [[ $fruit = apple ]]
ok [[ $fruit == apple ]]
ok [[ $((6 * 7)) -eq 42 ]]
ok $(ls | grep lib &> /dev/null; echo $?)
