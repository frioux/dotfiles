.PHONY: test

default:

test:
	prove $(PROVEOPT:%=% )test/
