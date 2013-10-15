# test/tap.bash - TAP Testing Foundation for Bash
#
# Copyright (c) 2013 Ingy döt Net

#------------------------------------------------------------------------------
Test::Tap:die() { echo "$@" >&2; trap EXIT; exit 255; }
#------------------------------------------------------------------------------

Test__Tap_VERSION=0.0.1

Test::Tap:init() {
  Test__Tap_plan=0
  Test__Tap_run=0
  Test__Tap_failed=0

  if [ $# -gt 0 ]; then
    [[ $# -eq 2 ]] ||
      Test::Tap:die 'Usage: test/tap.bash tests <number>'
    Test::Tap:plan "$@"
  fi

  trap Test::Tap:END EXIT
}

Test::Tap:plan() {
  [ $# -eq 2 ] ||
    Test::Tap:die 'Usage: plan tests <number>'
  if [ "$1" = tests ]; then
    [[ "$2" =~ ^-?[0-9]+$ ]] ||
      Test::Tap:die 'Plan must be a number'
    [[ $2 -gt 0 ]] ||
      Test::Tap:die 'Plan must greater then 0'
    Test__Tap_plan=$2
    printf "1..%d\n" $Test__Tap_plan
  elif [ "$1" == skip_all ]; then
    printf "1..0 # SKIP $2\n"
    exit 0
  else
    Test::Tap:die 'Usage: plan tests <number>'
  fi
}

Test::Tap:pass() {
  let Test__Tap_run=Test__Tap_run+1
  local label="$1"
  if [ -n "$label" ]; then
    echo "ok $Test__Tap_run - $label"
  else
    echo "ok $Test__Tap_run"
  fi
}

Test__Tap_CALL_STACK_LEVEL=1
Test::Tap:fail() {
  let Test__Tap_run=Test__Tap_run+1
  local c=( $(caller $Test__Tap_CALL_STACK_LEVEL) )
  local file=${c[2]}
  local line=${c[0]}
  local label="$1"
  if [ -n "$label" ]; then
    echo "not ok $Test__Tap_run - $label"
  else
    echo "not ok $Test__Tap_run"
  fi
  label=${label:+"'$label'\n#   at $file line $line."}
  label=${label:-"at $file line $line."}
  echo -e "#   Failed test $label" >&2
}

Test::Tap:done_testing() {
  Test__Tap_plan=$Test__Tap_run
  echo 1..$Test__Tap_run
}

Test::Tap:diag() {
  local msg="$@"
  msg="# ${msg//$'\n'/$'\n'# }"
  echo "$msg" >&2
}

Test::Tap:note() {
  local msg="$@"
  msg="# ${msg//$'\n'/$'\n'# }"
  echo "$msg"
}

Test::Tap:BAIL_OUT() {
  TEST_TAP_BAIL_OUT_ON_ERROR="$@"
  : "${TEST_TAP_BAIL_OUT_ON_ERROR:=No reason given.}"
  exit 255
}

Test::Tap:END() {
  local rc=$?
  if [ $rc -ne 0 ]; then
    local bail="$TEST_TAP_BAIL_OUT_ON_ERROR"
    if [ -n "$bail" ]; then
      if [[ "$bail" =~ (1|true) ]]; then
        bail="because TEST_TAP_BAIL_OUT_ON_ERROR=$bail and status=$rc"
      fi
      echo "Bail out!  $bail"
      exit $rc
    fi
  fi

  for v in plan run failed; do eval local $v=\$Test__Tap_$v; done
  if [ $plan -eq 0 ]; then
    if [ $run -gt 0 ]; then
      echo "# Tests were run but no plan was declared." >&2
    fi
  else
    if [ $run -eq 0 ]; then
      echo "# No tests run!" >&2
    elif [ $run -ne $plan ]; then
      local msg="# Looks like you planned $plan tests but ran $run."
      [ $plan -eq 1 ] && msg=${msg/tests/test}
      echo "$msg" >&2
    fi
  fi
  local exit_code=0
  if [ $Test__Tap_failed -gt 0 ]; then
    exit_code=$Test__Tap_failed
    [ $exit_code -gt 254 ] && exit_code=254
    local msg="# Looks like you failed $failed tests of $run run."
    [ $Test__Tap_failed -eq 1 ] && msg=${msg/tests/test}
    echo "$msg" >&2
  fi
  exit $exit_code
}

# vim: sw=2:
