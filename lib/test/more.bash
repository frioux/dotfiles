# test/more.bash - Complete TAP test framework for Bash
#
# Copyright (c) 2013 Ingy döt Net

set -e

Test__More_VERSION=0.0.1

source bpan
bpan:include 'test/tap'

plan() { Test::Tap:plan "$@"; }
pass() { Test::Tap:pass "$@"; }
fail() { Test::Tap:fail "$@"; }
diag() { Test::Tap:diag "$@"; }
note() { Test::Tap:note "$@"; }
done_testing() { Test::Tap:done_testing; }

is() {
  local Test__Tap_CALL_STACK_LEVEL=$(( Test__Tap_CALL_STACK_LEVEL + 1 ))
  local got="$1" want="$2" label="$3"
  if [ "$got" == "$want" ]; then
    pass "$label"
  else
    fail "$label"
    if [[ "$want" =~ \n ]]; then
      echo "$got" > /tmp/got-$$
      echo "$want" > /tmp/want-$$
      diff -u /tmp/{want,got}-$$ >&2
      wc /tmp/{want,got}-$$ >&2
      rm -f /tmp/{got,want}-$$
    else
      diag "\
      got: '$got'
   expected: '$want'"
    fi
  fi
}

isnt() {
  local Test__Tap_CALL_STACK_LEVEL=$(( Test__Tap_CALL_STACK_LEVEL + 1 ))
  local got="$1" dontwant="$2" label="$3"
  if [ "$got" != "$dontwant" ]; then
    pass "$label"
  else
    fail "$label"
    diag "\
      got: '$got'
   expected: anything else"
  fi
}

ok() {
  local args=("$@")
  local last=$((${#args[@]} - 1))
  local label=''
  local ending_re='^]]?$'
  local rc=
  if [[ $last -gt 0 ]] && [[ ! "${args[$last]}" =~ $ending_re ]]; then
    label="${args[$last]}"
    unset args[$last]
  fi
    rc=0
  if [[ ${#args[@]} -eq 1 ]] && [[ "${args[0]}" =~ ^[0-9]+$ ]]; then
    rc=${args[0]}
  elif [ ${args[0]} == '[[' ]; then
    # XXX Currently need eval to support [[. Is there another way?
    eval "${args[@]}" || rc=$?
  else
    "${args[@]}" &> /dev/null || rc=$?
  fi
  if [ $rc -eq 0 ]; then
    pass "$label"
  else
    fail "$label"
  fi
  return $rc
}

[[ "${BASH_SOURCE[0]}" != "${0}" ]] && Test::Tap:init "$@"

# vim: set sw=2:
