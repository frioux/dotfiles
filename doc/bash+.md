bash+(1) - Modern Bash Programming Framework
============================================

[![Build Status](https://travis-ci.org/ingydotnet/bashplus.png?branch=master)](https://travis-ci.org/ingydotnet/bashplus)

## SYNOPSIS

    source bash+ :std :array

    use Foo::Bar this that

    Array.new args "$@"

    if args.empty?; then
        die "I need args!"
    fi

    Foo::Bar.new foo args

    this is awesome     # <= this is a real command! (You just imported it)

## DESCRIPTION

Bash+ is just Bash... *plus* some libraries that can make bash programming a
lot nicer.

## INSTALLATION

Get the source code from GitHub:

    git clone git@github.com:BPAN-org/bashplus

Then run:

    make test
    make install        # Possibly with 'sudo'

## USAGE

For now look at some libraries the use Bash+:

* https://github.com/BPAN-org/git-hub
* https://github.com/BPAN-org/json-bash
* https://github.com/BPAN-org/test-more-bash

## STATUS

This stuff is really new. Watch the https://github.com/BPAN-org/ for
developments.

If you are interested in chatting about this, `/join #bpan` on
irc.freenode.net.

## AUTHOR

Written by Ingy döt Net <ingy@bpan.org>

## COPYRIGHT

Copyright 2013 Ingy döt Net
