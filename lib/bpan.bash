# bpan.bash - BPAN Package Installer and Bootstrap Library
#
# Copyright (c) 2013 Ingy döt Net

set -e

bpan:fcopy() {
    [ "$(type -t "$1")" == function ] ||
        bpan:die "'$1' is not a function"
    local func=$(type "$1" 3>/dev/null | tail -n+3)
    if [ -n "$3" ]; then
        "$3"
    else
        func="${func//bpan:/}"
    fi
    eval "$2() $func"
}

bpan:include() {
    local library_name="$1"; shift
    local library_path="$(bpan:find_inc $library_name)"
    [ -n "$library_path" ] || {
        local DIE_STACK_LEVEL=1
        bpan:die "Can't include '$library_name'. Not found."
    }
    source "$library_path" "$@"
}

bpan:find_inc() {
    local library_name="$1.bash"
    find ${INC//:/ } -name ${library_name##*/} 2>/dev/null |
        grep -E "$library_name\$" |
        head -n1
}

bpan:die() {
    local c=($(caller ${DIE_STACK_LEVEL:-0}))
    local msg="${@//\\n/$'\n'}"
    if [ -z "$msg" ]; then
        bpan:err- 'Died'
    else
        bpan:err- "$msg"
    fi
    local trailing_newline_re=$'\n''$'
    [[ "$msg" =~ $trailing_newline_re ]] && exit 1

    if [ ${#c[@]} -eq 2 ]; then
        printf " at line %d of %s\n" ${c[@]} >&2
    else
        printf " at line %d in %s of %s\n" ${c[@]} >&2
    fi
    exit 1
}

bpan:warn() {
    local msg="${@//\\n/$'\n'}"
    if [ -z "$msg" ]; then
        bpan:err 'Warning'
    else
        bpan:err "$msg"
    fi
}

bpan:out() { echo -e "$@" >&1; }
bpan:out-() { echo -n "$@" >&1; }
bpan:err() { echo -e "$@" >&2; }
bpan:err-() { echo -n "$@" >&2; }

bpan:prompt() {
    local msg answer default yn=false password=false
    case $# in
        0) msg='Press <ENTER> to continue, or <CTL>-C to exit.' ;;
        1)
            msg="$1"
            if [[ "$msg" =~ \[yN\] ]]; then
                default='n'
                yn=true
            elif [[ "$msg" =~ \[Yn\] ]]; then
                default='y'
                yn=true
            fi
            ;;
        2)
            msg="$1"
            default="$2"
            ;;
        *) bpan:die "Invalid usage of prompt" ;;
    esac
    if [[ "$msg" =~ [Pp]assword ]]; then
        password=true
        msg=$'\n'"$msg"
    fi
    while true; do
        if $password; then
            read -s -p "$msg" answer
        else
            read -p "$msg" answer
        fi
        [ $# -eq 0 ] && return 0
        [ -n "$answer" -o -n "$default" ] && break
    done
    if $yn; then
        [[ "$answer" =~ ^[yY] ]] && echo y && return 0
        [[ "$answer" =~ ^[nN] ]] && echo n && return 0
        echo "$default"
        return 0
    fi
    if [ -n "$answer" ]; then
        echo "$answer"
    else
        echo "$default"
    fi
}

# bpan.bash needs to be loaded by the 'bpan' executable.
[ -n "$BPAN_VERSION" ] ||
    bpan:die "Don't 'source bpan.bash'. Instead 'source bpan'."
# Make sure a different BPAN was not loaded:
[ "$BPAN_VERSION" == '0.0.1' ] ||
    bpan:die 'BPAN version mismatch'
