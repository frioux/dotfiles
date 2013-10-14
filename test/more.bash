PATH="$(
  IFS=':'
  set -- \
    $PWD/lib \
    $PWD/ext/*/{bin,lib}
  echo "$*"
):$PATH"

. \
bpan
bpan:include 'test/more'

# vim: set sw=2:
