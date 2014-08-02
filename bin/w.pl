#!/usr/bin/env perl

use 5.20.0;
use warnings;

use experimental 'signatures';
use autodie;

use IO::Async::Timer::Periodic;
use IO::Async::Loop;
use Net::Async::HTTP;
use URI;
use Future::Utils 'fmap_void';

my $loop = IO::Async::Loop->new;

my $http = Net::Async::HTTP->new(timeout => 60);

$loop->add($http);

update_weather();
my $timer = IO::Async::Timer::Periodic->new(
   interval => 10 * 60,

   on_tick => \&update_weather,
);

$loop->add( $timer->start );

$loop->run;

sub update_weather {
   my $f = fmap_void {
      my $code = shift;

      warn "updating $code\n";
      $http->do_request(
         uri => URI->new( "http://weather.noaa.gov/pub/data/observations/metar/decoded/$code.TXT" ),
      )->transform(
         done => sub ($response) {
            open my $fh, '>', "$ENV{HOME}/tmp/$code";
            print $fh $response->decoded_content
         },
         fail => sub ($message, @) { warn "$code retrieval failed: $message" },
      )
   } foreach => [qw(KBIX KADS KHQZ)];

   $f->get
}
