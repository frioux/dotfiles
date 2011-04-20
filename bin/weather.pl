#!/usr/bin/env perl
use 5.12.1;
use warnings;

use Weather::Com::Finder;

my $PartnerId  = '1014868712';
my $LicenseKey = 'db660d449a5a4646';

my $iconpath = '/home/frew/icons';

my %weatherargs = (
  partner_id => $PartnerId,
  license    => $LicenseKey,
);

my $weather_finder = Weather::Com::Finder->new(%weatherargs);

# Fill in your location
my $locations = $weather_finder->find('Plano, TX');

my $temp_today = $locations->[0]->current_conditions()->temperature() * 1.8 + 32;
my $desc_today = $locations->[0]->current_conditions()->description();

my $color = '';

$color = 'red'  if $temp_today >= 80;
$color = 'blue' if $temp_today <= 67;

say "^fg($color)$desc_today ${temp_today}°^fg()";

