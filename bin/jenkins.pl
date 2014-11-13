#!/usr/bin/env perl

use 5.20.1;
use warnings;
use Term::ANSIColor;
binmode STDOUT, ':encoding(utf8)';

use experimental 'postderef', 'signatures';

use Jenkins::API;

my $m = sub { +{ map %$_, @{$_[0]} } };
my $kv = sub { +{ map { $_->{name} => $_->{value } } @{$_[0]} } };
sub rn ($d) {
   $d->{actions}->$m->{parameters}->$kv->{refname}
      =~ s(^refs/(?:heads|tags)/)()r
}
sub ce ($d) {
   colored(['bright_black'], $d->{actions}->$m->{parameters}->$kv->{committer_email})
}
sub status ($d) {
   return {
      undef => colored(['yellow'], "\x{21BB}"),
      SUCCESS => colored(['green'], "\x{2713}"),
      FAILURE => colored(['red'], "\x{2716}"),
   }->{$d->{result} // 'undef'}
}

my $j = Jenkins::API->new({ base_url => $ENV{CIURL} });
printf "%i: %s %s %s\n", $_->{number}, status($_), rn($_), ce($_) for
   $j->current_status({
         path_parts => [qw( job LynxTests )],
         extra_params => { depth => 1 }
      })->{builds}->@*
