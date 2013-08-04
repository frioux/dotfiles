#!/bin/bash

source test-simple.bash tests 10

fruit=apple

ok true                         'true is ok'
ok false '||' true              "With quoted '||'"
ok [ $fruit = apple ]           '$fruit is apple'
ok [ ${fruit/a/A} = Apple ]     'Capitalize first letter'
ok [ "${fruit}s" = apples ]     Plural
ok [[ $fruit = apple ]]         '[[ ... ]] works'
ok [[ $fruit == apple ]]        '== works'
ok [[ $((6 * 7)) -eq 42 ]]      '-eq works with math expression'
ok '((' 42 '))'                 'Arithmetic expansion'
ok '(' echo foo ')'             'Subshell'
