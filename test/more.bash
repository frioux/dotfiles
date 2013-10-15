INC="$(
  set -- \
    $PWD/lib \
    $PWD/ext/*/{bin,lib}
  IFS=':'; echo "$*"
)"
PATH="$INC:$PATH"

. \
bpan
bpan:include 'test/more'

# vim: set sw=2:
