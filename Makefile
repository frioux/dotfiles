.PHONY: test
test: ext
	prove $(PROVEOPT) test/

ext:
	git submodule update --init
