#!/usr/bin/env perl

my $str = require 'unicore/Name.pl';

open my $fh, '<', \$str
    or die "Cannot open unicore data: $!$/";

while (<$fh>) {
    chomp;
    (/(.+)\t([^;]+)/) or next;

    my ($code, $name) = ($1, $2);

    next if $code =~ / /; # if we want to avoid named sequences
    print lc $name, ' ', $/;
}

close $fh;
