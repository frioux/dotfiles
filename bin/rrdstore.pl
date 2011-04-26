#!/usr/bin/perl

use 5.10.1;

use strict;
use warnings;

use constant {
   used => 0,
   buff => 1,
   cach => 2,
   free => 3,
   batt => 4,
   usr  => 5,
   sys  => 6,
   idl  => 7,
   wai  => 8,
   hig  => 9,
   sig  => 10,
   thrm => 11,
};

use Weather::Com::Finder;
use RRDTool::OO;
use POSIX 'strftime';

my $weather_finder = Weather::Com::Finder->new(
   partner_id => '1014868712',
   license    => 'db660d449a5a4646',
);
my $weather_counter = 60;

my $rrd = RRDTool::OO->new( file => 'test.rrd' );
my $iconpath = '/home/frew/icons';

sub gauge_def {
(
   data_source => { name      => $_[0],
                    type      => 'GAUGE' },
   archive     => { rows      => 60*8, # eight hours
                    cpoints   => 60,
                    cfunc     => 'AVERAGE',
                  },
   archive     => { rows      => 60*8 / 5, # eight hours
                    cpoints   => 5*60,
                    cfunc     => 'AVERAGE',
                  },
   archive     => { rows      => 60*8 / 15, # eight hours
                    cpoints   => 15*60,
                    cfunc     => 'AVERAGE',
                  },
)
}

sub get_data {
   my ($time, $resolution) = @_;
   my $end = int($time/$resolution)*$resolution;
   $rrd->fetch_start(
      cfunc      => 'AVERAGE',
      start      => $end - $resolution,
      end        => $end,
      resolution => $resolution,
   );
   $rrd->fetch_skip_undef;

   my $ret;
   while(my($time, @values) = $rrd->fetch_next()) {
      $ret = \@values if @values
   }
   $ret
}

sub load_weather {
   my $ret = eval {
      my $locations = $weather_finder->find('Plano, TX');

      my $temp_today = int $locations->[0]->current_conditions()->temperature() * 1.8 + 32;
      my $desc_today = $locations->[0]->current_conditions()->description();

      my $color = '';

      $color = 'red'  if $temp_today >= 80;
      $color = 'blue' if $temp_today <= 67;

      return "^ca(1, /home/frew/tmp/firefox/firefox http://www.weather.com/weather/today/Plano+TX+75074)^fg($color)$desc_today ${temp_today}°F^fg()^ca()";
   };
   return $ret || ();
}

{
   my @weather = load_weather;
   sub get_weather {
      $weather_counter--;
      if ($weather_counter < 0) {
         @weather = load_weather;
         $weather_counter = 60;
      }
      @weather;
   }
}

sub get_battery {
   my $percent = spritnf '%.0f', $_[0];

   return () if $percent == 100;

   my $color = '';
   $color    = 'red' if $percent <= 20;

   return "^ca(1, ./cpugraph.pl batt && feh out.png)^fg($color)^i(${iconpath}/power-bat2.xbm)^p(2)$percent^fg()^ca()";
}

sub render_temp {
   my $val = shift;
   my $cpu_color = '';
   $cpu_color = 'red' if $val >= 60;

   sprintf '^ca(1, ./cpugraph.pl thrm && feh out.png)^fg(%s)^i(/home/frew/icons/cpu.xbm)^p(2)%i°C^fg()^ca()', $cpu_color, $val
}

sub render_processor {
   my $val = shift;

   sprintf '^ca(1, ./cpugraph.pl idl && feh out.png)^p(2)%%%02i^fg()^ca()', $val
}

sub render_free {
   my $val = shift;

   $val = $val
      / 2**10 # K
      / 2**10 # M
      / 2**10; # G
   sprintf "^ca(1, ./cpugraph.pl free && feh out.png)^p(2)%01.02f G^fg()^ca()", $val
}

sub de_time {
   local $ENV{TZ}='Europe/Berlin';
   my $de_date = strftime('%l:%M %p', localtime);
   $de_date =~ s/^\s+//g;
   "riba: $de_date"
}

sub my_date {
   my $my_date = strftime('%a %b %d, %l:%M %p', localtime);
   $my_date = join ' ', split /\s+/, $my_date;
   "^ca(1, xterm -e 'cal && read foo')^fg(white)$my_date^fg()^ca()"
}

$rrd->create(
   step        => 1,
   map gauge_def($_), qw(used buff cach free batt usr sys idl wai hig sig thrm),
) unless -f 'test.rrd';

while (<>) {
   chomp(my $data = qx(tail -n1 out.csv));
   my @current = split /,/, $data;
   $rrd->update( values => \@current );

   my $time = time;
   my @one_min     = get_data($time, 60);
   my @five_min    = get_data($time, 60*5);
   my @fifteen_min = get_data($time, 60*15);

   open my $fh, '>', 'lol';

   say {$fh} join ' ^fg(orange)|^fg() ',
      render_processor(100 - $current[idl]),
      render_free($current[free]),
      get_battery($current[batt]),
      render_temp($current[thrm]),
      de_time(),
      get_weather(),
      my_date(),
}
