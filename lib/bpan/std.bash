bpan:std:dei() {
    echo "$@" | rev >&2
    exit 42
}
