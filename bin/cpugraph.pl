#!/usr/bin/perl

use strict;
use warnings;

use RRDTool::OO;
my $rrd = RRDTool::OO->new( file => 'test.rrd' );
my $arg = shift;
$rrd->graph(
   image          => 'out.png',
   #vertical_label => 'CPU Temp',
   start          => time() - 60*60*5,
   end            => time(),
   draw           => {
     type   => "line",
     thickness => 2,
     color     => 'FF0000', # red area
     dsname    => $arg,
     cfunc     => 'AVERAGE'
   },
 );
