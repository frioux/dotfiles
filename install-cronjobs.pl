#!/usr/bin/env perl

use strict;
use warnings;

use Config::Crontab;

my $ct = Config::Crontab->new;

$ct->read;

$ct->remove($ct->block($ct->select(-command_re => qr[/bin/daily-notifications])));

$ct->remove($ct->block($ct->select(-command_re => qr/notmuch new/)));
$ct->last(
   Config::Crontab::Block->new( -lines => [
         Config::Crontab::Event->new(
            -minute => 0,
            -command => "zsh -c 'notmuch new > /dev/null 2>&1'",
         )
      ]
   )
);

$ct->write;
