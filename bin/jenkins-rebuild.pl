#!/usr/bin/env perl

use 5.20.1;
use warnings;

use Jenkins::API;

my $kv = sub { +{ map { $_->{name} => $_->{value } } @{$_[0]} } };
my $j = Jenkins::API->new({ base_url => $ENV{CIURL} });

my $success = $j->trigger_build_with_parameters(Lynx =>
   $j->current_status({
      path_parts => [qw( job Lynx ), shift],
      extra_params => { depth => 0 }
   })->{actions}[0]{parameters}->$kv
);

if ($success) {
   say "BUILDING!"
} else {
   die "FAILED! $success\n";
}
