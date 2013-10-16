#!/usr/bin/env bash

source test/setup

include 'test/more' tests 3

pass 'pass 1 - with label'
pass
pass 'pass 3 - 2 has no label'
