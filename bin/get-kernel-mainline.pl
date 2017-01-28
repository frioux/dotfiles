#!/usr/bin/env perl

use strict;
use warnings;

my $all = shift
   or die "Usage: $0 http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.8.1/linux-headers-4.8.1-040801_4.8.1-040801.201610071031_all.deb\n";
my $headers = $all =~ s/all/amd64/r;
$headers =~ s/_/-generic_/;
my $image = $headers =~ s/headers/image/r;

system 'wget', $_ for $all, $headers, $imageA;
