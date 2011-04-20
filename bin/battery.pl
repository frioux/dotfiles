#!/usr/bin/env perl

use 5.12.1;
use warnings;

my $iconpath = '/home/frew/icons';

my %state = do {
   my $file = '/proc/acpi/battery/BAT1/state';
   open my $fh, '<', $file;
   map { chomp; split /:\s+/ } <$fh>;
};

exit if $state{'charging state'} eq 'charged';

my %info = do {
   my $file = '/proc/acpi/battery/BAT1/info';
   open my $fh, '<', $file;
   map { chomp; split /:\s+/ } <$fh>;
};

my $percent = sprintf '%i', 100 * [split /\s+/, $state{'remaining capacity'}]->[0]
   / [split /\s+/, $info{'last full capacity'}]->[0];

my $color = '';
$color    = 'red'  if $percent <= 20;

say "^fg($color)^i(${iconpath}/power-bat2.xbm)^p(2)$percent^fg() | ";

