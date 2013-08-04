#!/bin/bash

question() { echo yes; }

source test-simple.bash tests 4

answer=$(question "...?")
ok [ $answer == yes ]   'The answer is yes!'
ok [[ $answer =~ ^y ]]  'The answer begins with y'
ok true                 'true is ok'
ok '! false'            '! false is true'
