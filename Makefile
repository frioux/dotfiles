.PHONY: test install uninstall

ifndef INSTALL_LIB
    INSTALL_LIB=/usr/local/lib/bash
endif


test:
	PATH=lib:$$PATH prove -ebash -v test
