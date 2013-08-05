#!/bin/bash

PATH=lib:$PATH
source test-simple.bash tests 14

ok 0                            '0 is true'
ok $((6 * 7 -42))               'Math result is 0'
ok true                         'true is ok'
ok $(false || true; echo $?)    'Expression expansion'

ls &> /dev/null
ok $?                           '$? is success'
ls --qqq &> /dev/null
ok $((! $?))                    'Negate $? failure'

fruit=apple

ok [ $fruit = apple ]           '[ … ] testing works'
ok [ "0" == "0" -a 1 -eq 1 ]    '[ … -a … ] (AND) testing works'
ok [ ${fruit/a/A} = Apple ]     'Substitution expansion works'
ok [ "${fruit}s" = 'app''les' ] 'Quote removal works'
ok [[ $fruit = apple ]]         '[[ … ]] works'
ok [[ $fruit == apple ]]        '== works'
ok [[ $((6 * 7)) -eq 42 ]]      '-eq works with math expression'
ok $(ls | grep lib &> /dev/null; echo $?) \
                                'Testing a grep command works'
