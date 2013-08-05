#!/bin/bash

question() { echo yes; }

PATH=lib:$PATH
source test-simple.bash tests 5

ok 0                    '0 is true (other numbers are false)'

answer=$(question "...?")
ok [ $answer == yes ]   'The answer is yes!'
ok [[ $answer =~ ^y ]]  'The answer begins with y'

ok true                 'true is ok'
ok '! false'            '! false is true'
