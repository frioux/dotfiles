#!/usr/bin/env bash

source lib/test/tap.bash

Test::Tap:init tests 5
Test::Tap:FAIL_FAST

Test::Tap:pass 'test #1'
Test::Tap:pass 'test #2'
Test::Tap:fail 'test #3'
Test::Tap:pass 'test #4'
Test::Tap:pass 'test #5'

# vim: set sw=2 ft=sh:
