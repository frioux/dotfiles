# bpan.bash - BPAN Package Installer and Bootstrap Library
#
# Copyright (c) 2013 Ingy döt Net

set -e

# bpan.bash needs to be loaded by the 'bpan' executable.
[ -n "$BPAN_VERSION" ] ||
    bpan:die "Don't 'source bpan.bash'. Instead 'source bpan'."
# Make sure a different BPAN was not loaded:
[ "$BPAN_VERSION" == '0.0.1' ] ||
    bpan:die 'BPAN version mismatch'


# Usage: bpan:include 'foo/bar'
# Searches $PATH for foo/bar.bash'
bpan:include() {
    # XXX need input validation
    local library_name="$1"; shift
    source "$(bpan:_resolve_path $library_name)"
}

# TODO use die/say/warn code from git-hub
bpan:die() {
    echo "$@" >&2
    exit 1
}

bpan:warn() {
    echo "$@" >&2
}

# TODO should we use BPAN_PATH instead of PATH?
bpan:_resolve_path() {
    local library_name="$1.bash"
    # Find a multi-part name ( foo/bar.bash ) in PATH:
    find ${PATH//:/ } -name ${library_name##*/} 2>/dev/null |
        grep -E "$library_name\$" |
        head -n1
}

# bpan:import() {
#     local lib
#     for lib in "$@"; do
#         bpan:use $lib || exit $?
#     done
# }

# bpan:Export() {
#     : # Copy a function name $1 to $2
# }

# include + import
# bpan:use() {
#     [ $# -ge 1 ] ||
#         bpan:die '$cmd requires a library name'
#     [[ "$1" =~ ^[-:/a-zA-Z0-9]+$ ]] ||
#         bpan:die "Invalid library name '$1'"
#     local lib=$1; shift
#     [[ $lib =~ ^: ]] && lib="bpan$lib"
#     lib="$lib.bash"
#     local PATH=$BPAN_LIB
#     source $lib "$@"
# }
