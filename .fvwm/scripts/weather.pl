#!/usr/bin/perl -Tw
$|++;
#==========================================================================
#
#         FILE:  weather.pl
#
#        USAGE:  ./weather.pl 
#
#  DESCRIPTION:  Script do get and print weather conditions from weather.com
#
# REQUIREMENTS:  Weather::Cached
#       AUTHOR:  Miguel Santinho (), <msantinho@simplicidade.com>
#      COMPANY:  Simplicidade.com
#      VERSION:  1.1
#      CREATED:  02-09-2005 21:27:30 WEST
#     REVISION:  05-09-2005 19:19:45 WEST
#==========================================================================
#==========================================================================
#  This program is free software; you can redistribute it and/or modify 
#  it under the terms of the GNU General Public License as published by 
#  the Free Software Foundation; either version 2 of the License, or    
#  (at your option) any later version.                                  
#==========================================================================

use strict;
use Weather::Cached;


#==========================================================================
#  Configurations
#==========================================================================

# Make sure your location is available from www.weather.com, or you won't get
# any info.

# Your City
my $city = "Longview";

# Your Country
my $country = "US";

# Label for your location
my $city_title = "Longview";

# Path for your icons folder
my $icons = "/home/frew/.fvwm/sdk/";

# modify, at least, your partner ID and your License number
my %params = (
	current    => 1,        # Show current
	units      => 'm',      # Units
	ut         => 'C',      # (C)elsius
	cache      => '/tmp',   # Where to store the temporary files
	timeout    => 250,      # Time to update information
	partner_id => '1014868712',
	license    => 'db660d449a5a4646',
	forecast   => 7, # 7 days from today
);

# Labels for weekdays columns headers
my $dias = {
	Monday    => 'MON',
	Tuesday   => 'TUE',
	Wednesday => 'WED',
	Thursday  => 'THU',
	Friday    => 'FRI',
	Saturday  => 'SAT',
	Sunday    => 'SUN',
};


#==========================================================================
#  Program
#==========================================================================

my $cached_weather = Weather::Cached->new(%params);
my $locations = $cached_weather->search("$city, $country") or die "Error!\n";

foreach my $cidade (keys %{$locations}) {

	my $weather = $cached_weather->get_weather($cidade);

	# Line for current
	print "$city_title\n",
	$icons . $weather->{cc}->{icon} . ".png\n",
	$weather->{cc}->{tmp} , "º\n";
	
	foreach my $dia ($weather->{dayf}->{day}) {
		for ( 0 .. 6 ) { # next 7 days

			print $dias->{$dia->[$_]->{t}}, "\n", # Weekdays
			
			      $icons . "32x32/" . $dia->[$_]->{part}->[0]->{icon} . 
				  ".png\n", # Icons
				  
				  $dia->[$_]->{hi}; # High
				  
			print "º" if $dia->[$_]->{hi} ne 'N/A';
			
			print "\n", $dia->[$_]->{low}, "º\n"; # Low
		}
	}
}

