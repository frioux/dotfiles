PATH="$PWD/lib:$(IFS=':';set -- $PWD/ext/*/{bin,lib};echo "$*"):$PATH"
source bpan; bpan:include 'test/more'
