#!/usr/bin/env perl

use strict;
use warnings;

use Config::Crontab;

my $ct = Config::Crontab->new;

$ct->read;

$ct->remove($ct->block($ct->select(-command_re => '/bin/daily-notifications')));
$ct->last(
   Config::Crontab::Block->new( -lines => [
         Config::Crontab::Event->new(
            -minute => 0,
            -hour   => 8,
            -command => "$ENV{HOME}/bin/daily-notifications",
         )
      ]
   )
);
$ct->write;
