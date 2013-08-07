.PHONY: default help doc test \
    install install-lib install-doc \
    uninstall uninstall-lib uninstall-doc

CMD := test-simple.bash

# XXX This is a very crude default. Be smarter here…
PREFIX ?= /usr/local
INSTALL_LIB ?= $(PREFIX)/lib/bash
INSTALL_MAN ?= $(PREFIX)/share/man/man1

# User targets:
default: help

help:
	@echo 'Makefile rules:'
	@echo ''
	@echo 'test       Run all tests'
	@echo 'install    Install $(CMD)'
	@echo 'uninstall  Uninstall $(CMD)'
	@echo 'clean      Remove build/test files'

test: $(TEST_SIMPLE)
	prove $(PROVE_OPTIONS) test/

install: install-lib install-doc

install-lib: $(INSTALL_LIB)
	install -m 0755 lib/$(CMD) $(INSTALL_LIB)/

install-doc:
	install -c -d -m 0755 $(INSTALL_MAN)
	install -c -m 0644 doc/$(CMD).1 $(INSTALL_MAN)

uninstall: uninstall-lib uninstall-doc

uninstall-lib:
	rm -f $(INSTALL_LIB)/$(CMD)

uninstall-doc:
	rm -f $(INSTALL_MAN)/$(CMD).1

clean purge:
	true

##
# Sanity checks:
$(SUBMODULE):
	@echo 'You need to run `git submodule update --init` first.' >&2
	@exit 1

##
# Builder rules:
doc: doc/$(CMD).1

$(CMD).txt: doc/$(CMD).asc
	cp $< $@

%.xml: %.txt
	asciidoc -b docbook -d manpage -f doc/asciidoc.conf $^
	rm $<

%.1: %.xml
	xmlto -m doc/manpage-normal.xsl man $^
	mv test-simple.1 $(CMD).1

doc/%.1: %.1
	mv $< $@

$(INSTALL_LIB):
	mkdir -p $@
