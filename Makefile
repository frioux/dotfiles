EXT = \
	ext/bpan-bash/lib \
	ext/test-more-bash/lib \

.PHONY: test
test: $(EXT)
	prove $(PROVEOPT) test/

$(EXT):
	git submodule update --init
