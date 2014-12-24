#!/usr/bin/env perl

use 5.20.1;
use warnings;

use experimental 'postderef', 'signatures';

use Jenkins::API;
use List::Util 'first';

my $m = sub { +{ map %$_, @{$_[0]} } };
my $kv = sub { +{ map { $_->{name} => $_->{value } } @{$_[0]} } };
sub rn ($d) {
   $d->{actions}->$m->{parameters}->$kv->{refname}
      =~ s(^refs/(?:heads|tags)/)()r
}
sub ce ($d) {
   $d->{actions}->$m->{parameters}->$kv->{committer_email}
}

die "please give the build numbers you'd like to see the details of\n"
   if @ARGV == 0;

my $j = Jenkins::API->new({ base_url => $ENV{CIURL} });
for my $id (@ARGV) {
   my $d = $j->current_status({
      path_parts => [qw( job LynxTests ), $id],
      extra_params => {
         tree => 'actions[parameters[name,value],childReports[child[url],result[failCount,suites[name,cases[status]]]]]',
      }
   });

   say "$id failures: (" . rn($d) . ')';
   for my $server (grep $_->{result}{failCount}, $d->{actions}->$m->{childReports}->@*) {
      my @failed_tests =
         map $_->{name} =~ s/_t$//r,
         grep { first { $_->{status} =~ m/(?:FAILED|REGRESSION)/ } $_->{cases}->@* }
         $server->{result}{suites}->@*;

      next unless @failed_tests;

      say(' ' . ($server->{child}{url} =~ s[.*label=(.+?)/.*][$1]r) ."\n" . join q(), map "  • $_\n", @failed_tests);
   }
}
