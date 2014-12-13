#!/usr/bin/env perl

use 5.20.1;
use warnings;

die "usage: gin-pass.pl \$password \$cost\n"
   unless @ARGV == 2;

my ($password, $cost) = @ARGV;

use Time::HiRes qw( gettimeofday tv_interval );

use Authen::Passphrase::BlowfishCrypt;

my $t0 = [gettimeofday];

say Authen::Passphrase::BlowfishCrypt->new(
   cost => $cost,
   salt_random => 1,
   passphrase => $password,
)->as_crypt;

warn sprintf "%0.2fs elapsed\n", tv_interval($t0);
