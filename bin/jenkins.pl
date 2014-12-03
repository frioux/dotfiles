#!/usr/bin/env perl

use 5.20.1;
use warnings;
use Term::ANSIColor;
use DateTime;
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
   my $ce = $d->{actions}->$m->{parameters}->$kv->{committer_email};
   colored(['bright_black'], (split '@', $ce)[0])
}
sub status ($d) {
   return {
      undef => colored(['yellow'], "\x{21BB}"),
      SUCCESS => colored(['green'], "\x{2713}"),
      FAILURE => colored(['red'], "\x{2716}"),
      ABORTED => colored(['bright_black'], "\x{2716}"),
   }->{$d->{result} // 'undef'} || colored(['white'], "?"),
}
sub started ($d) {
   my $t = DateTime->from_epoch(epoch => $d->{timestamp}/1000);
   $t->set_time_zone('local');
   $t->strftime('%F %T');
}
sub duration ($d) {
   my $start = DateTime->from_epoch(epoch => $d->{timestamp}/1000);
   my $seconds = $d->{result} ? $d->{duration} : $d->{estimatedDuration};
   my $end = DateTime->from_epoch(epoch => ($d->{timestamp} + $seconds)/1000);
   my $dur = $d->{result} ? $start->delta_ms($end) : DateTime->now->delta_ms($end);
   sprintf "%s %02d:%02d",
      $d->{result} ? colored(['green'], "\x{0394}") : colored(['yellow'],"\x{21BB}"),
      $dur->minutes, $dur->seconds,
}

my $j = Jenkins::API->new({ base_url => $ENV{CIURL} });
printf "%s #%i %s %s %s %s\n",
   started($_), $_->{number}, status($_), rn($_), ce($_), duration($_),
   for $j->current_status({
         path_parts => [qw( job LynxTests )],
         extra_params => { depth => 1 }
      })->{builds}->@*
