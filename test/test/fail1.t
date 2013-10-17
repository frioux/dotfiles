#!/usr/bin/env bash

source test/setup
include 'test/more'

fail 'fail with label'

fail

is foo bar 'is foo bar'


done_testing
