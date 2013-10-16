#!/usr/bin/env bash

plan() {
  echo "1..$1"
}

pass() {
  let run=run+1
  local label="${1:+ - $1}"
  echo "ok $run$label"
}

fail() {
  let run=run+1
  local label="${1:+ - $1}"
  echo "not ok $run$label"
}

is() {
  if [ "$1" == "$2" ]; then
    pass "$3"
  else
    fail "$3"
    diag "Got:  $1"
    diag "Want: $2"
  fi
}

ok() {
  if [ $? -eq 0 ]; then
    pass "$1"
  else
    fail "$1"
  fi
}

like() {
  if [[ "$1" =~ "$2" ]]; then
    pass "$3"
  else
    fail "$3"
    diag "Got:  $1"
    diag "Like: $2"
  fi
}

unlike() {
  if [[ ! "$1" =~ "$2" ]]; then
    pass "$3"
  else
    fail "$3"
    diag "Got:  $1"
    diag "Dont: $2"
  fi
}

done_testing() {
  echo "1..$run"
}

diag() {
  echo "# ${1//$'\n'/$'\n'# }" >&2
}

note() {
  echo "# ${1//$'\n'/$'\n'# }"
}

# vim: set sw=2:
