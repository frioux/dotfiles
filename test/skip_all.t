#!/bin/bash

source lib/test/tap.bash

Test::Tap:init
Test::Tap:plan skip_all 'This is a test for skip_all'

Test::Tap:diag "This code should not be run"
Test::Tap:pass

# vim: set sw=2 ft=sh:
