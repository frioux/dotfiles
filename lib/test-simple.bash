# test-simple.bash - Simple TAP test framework for Bash
#
# Copyright (c) 2013 Ingy döt Net

TestSimple_VERSION='0.0.1'

TestSimple.init() {
    TestSimple_plan=0
    TestSimple_run=0
    TestSimple_failed=0
    TestSimple_usage='Usage: source test-simple.bash tests <number>'

    if [ $# -gt 0 ]; then
        [[ $# -eq 2 ]] && [[ "$1" == 'tests' ]] ||
            TestSimple.die "$TestSimple_usage"
        [[ "$2" =~ ^-?[0-9]+$ ]] ||
            TestSimple.die 'Plan must be a number'
        [[ $2 -gt 0 ]] ||
            TestSimple.die 'Plan must greater then 0'
        TestSimple_plan=$2
        printf "1..%d\n" $TestSimple_plan
    fi

    trap TestSimple.END EXIT
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
    if [[ ${#args[@]} -eq 1 ]] && [[ "${args[0]}" =~ ^[0-9]+$ ]]; then
        rc=${args[0]}
    elif [ ${args[0]} == '[[' ]; then
        # XXX Currently need eval to support [[. Is there another way?
        # Is [[ overkill? So many questons!
        eval "${args[@]}" &> /dev/null
        rc=$?
    else
        "${args[@]}" &> /dev/null
        rc=$?
    fi
    if [ $rc -eq 0 ]; then
        if [ -n "$label" ]; then
            echo ok $((++TestSimple_run)) - $label
        else
            echo ok $((++TestSimple_run))
        fi
    else
        let TestSimple_failed=TestSimple_failed+1
        if [ -n "$label" ]; then
            echo not ok $((++TestSimple_run)) - $label
            TestSimple.failure "$label"
        else
            echo not ok $((++TestSimple_run))
            TestSimple.failure "$label"
        fi
    fi
}

TestSimple.failure() {
    local c=( $(caller 1) )
    local file=${c[2]}
    local line=${c[0]}
    local label=$1
    label=${label:+"'$label'\n#   at $file line $line."}
    label=${label:-"at $file line $line."}
    echo -e "#   Failed test $label" >&2
}

TestSimple.END() {
    for v in plan run failed; do eval local $v=\$TestSimple_$v; done
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
    if [ $TestSimple_failed -gt 0 ]; then
        exit_code=$TestSimple_failed
        [ $exit_code -gt 254 ] && exit_code=254
        local msg="# Looks like you failed $failed tests of $run run."
        [ $TestSimple_failed -eq 1 ] && msg=${msg/tests/test}
        echo "$msg" >&2
    fi
    exit $exit_code
}

TestSimple.die() { echo "$@" >&2; trap EXIT; exit 255; }

[[ "${BASH_SOURCE[0]}" != "${0}" ]] && TestSimple.init "$@"
