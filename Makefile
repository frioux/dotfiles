.PHONY: test install uninstall

CMD=test-simple

ifndef INSTALL_LIB
    INSTALL_LIB=/usr/local/lib/bash
endif
MAN1DIR ?= /usr/local/share/man/man1

default: help

help:
	@echo 'Makefile rules:'
	@echo ''
	@echo 'test       Run all tests'
	@echo 'install    Install $(CMD)'
	@echo 'uninstall  Uninstall $(CMD)'
	@echo 'clean      Remove build/test files'

test:
	PATH=lib:$$PATH prove -ebash test/

install: install-lib install-doc

install-lib:
	install -m 0644 lib/$(CMD).bash $(INSTALL_LIB)/

install-doc:
	install -c -d -m 0755 $(MAN1DIR)
	install -c -m 0644 doc/$(CMD).1 $(MAN1DIR)

clean:
	true
