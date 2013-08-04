#!/bin/bash

source test-simple.bash tests 8

fruit=apple

ok true                         'true is ok'
ok true                         # No label
ok [ $fruit = apple ]           '$fruit is apple'
ok [ ${fruit/a/A} = Apple ]     'Capitalize first letter'
ok [ "${fruit}s" = apples ]     Plural
ok [[ $fruit = apple ]]         '[[ ... ]] works'
ok [[ $fruit == apple ]]        '== works'
ok [[ $((6 * 7)) -eq 42 ]]      '-eq works with math expression'
