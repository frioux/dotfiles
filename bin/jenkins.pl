#!/usr/bin/env perl

use 5.20.1;
use warnings;

use experimental 'postderef', 'signatures';

use Jenkins::API;

my $m = sub { +{ map %$_, @{$_[0]} } };
my $kv = sub { +{ map { $_->{name} => $_->{value } } @{$_[0]} } };
sub rn ($d) {
   $d->{actions}->$m->{parameters}->$kv->{refname}
      =~ s(^refs/(?:heads|tags)/)()r
}
sub ce ($d) {
   $d->{actions}->$m->{parameters}->$kv->{committer_email}
}

my $j = Jenkins::API->new({ base_url => $ENV{CIURL} });
printf "%i - %s (%s)\n", $_->{number}, rn($_), ce($_) for
   grep $_->{result} eq 'FAILURE',
   $j->current_status({
         path_parts => [qw( job LynxTests )],
         extra_params => { depth => 1 }
      })->{builds}->@*
