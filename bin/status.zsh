#!/bin/zsh
#
# xmonad statusline, (c) 2007 by Robert Manea
#

# Configuration
DATE_FORMAT='%a %b %d, %l:%M %p'
TIME_ZONES=(Europe/Berlin)
WEATHER_FORECASTER=weather.pl
BATTERYER=battery.pl

# Main loop interval in seconds
INTERVAL=1

# function calling intervals in seconds
BATTERYIVAL=60
DATEIVAL=1
GTIMEIVAL=60
CPUTEMPIVAL=1
WEATHERIVAL=1800
WIFIIVAL=60

# Functions
fdate() {
    date +$DATE_FORMAT
}

fgtime() {
    local i

    for i in $TIME_ZONES
        { print -n "${i:t}:" $(TZ=$i date +'%l:%M %p')' ' }
}

fcputemp() {
   print -n ${(@)$(</proc/acpi/thermal_zone/TZ00/temperature)[2]}
}

fwifi() {
   SIGNAL=$( /sbin/iwconfig wlan0 | sed -ne '/Link Quality/ { s/.*Link Quality:\([0-9]*\)\/\([0-9]*\).*/\1/p}' )
   GRAPH=$(echo $SIGNAL | /home/frew/code/dzen/gadgets/gdbar -s v -h 15 -ss 1 -sh 2 -sw 12 -fg $BFG  -bg $BBG -nonl)

   echo "W^p(2)$GRAPH^fg()";
}

fbattery() {
   $BATTERYER
}

fweather() {
   $WEATHER_FORECASTER
}


# Main

# initialize data
DATECOUNTER=$DATEIVAL;GTIMECOUNTER=$GTIMEIVAL;CPUTEMPCOUNTER=$CPUTEMPIVAL;WEATHERCOUNTER=$WEATHERIVAL
BATTERYCOUNTER=$BATTERYIVAL
WIFICOUNTER=$WIFIIVAL


while true; do
   CPUCOLOR=
   if [ $DATECOUNTER -ge $DATEIVAL ]; then
     PDATE=$(fdate)
     DATECOUNTER=0
   fi

   if [ $GTIMECOUNTER -ge $GTIMEIVAL ]; then
     PGTIME=$(fgtime)
     GTIMECOUNTER=0
   fi

   if [ $CPUTEMPCOUNTER -ge $CPUTEMPIVAL ]; then
     PCPUTEMP=$(fcputemp)
     CPUTEMPCOUNTER=0
   fi

   if [ $WEATHERCOUNTER -ge $WEATHERIVAL ]; then
     PWEATHER=$(fweather)
     WEATHERCOUNTER=0
   fi

   if [ $BATTERYCOUNTER -ge $BATTERYIVAL ]; then
     PBATTERY=$(fbattery)
     BATTERYCOUNTER=0
   fi

   if [ $WIFICOUNTER -ge $WIFIIVAL ]; then
     PWIFI=$(fwifi)
     WIFICOUNTER=0
   fi

   if [ $PCPUTEMP -ge 60 ]; then
      CPUCOLOR=red
   fi

   if [ $PCPUTEMP -le 30 ]; then
      CPUCOLOR=blue
   fi

   # Arrange and print the status line
   print "$PWIFI | ${PBATTERY}^fg($CPUCOLOR)^i(/home/frew/icons/cpu.xbm)^p(2)$PCPUTEMP°C^fg() | $PGTIME | $PWEATHER | ^fg(white)${PDATE}^fg() [^fg(red)^ca(1, echo 'start logout script here')X^ca()^fg()]"

   DATECOUNTER=$((DATECOUNTER+1))
   GTIMECOUNTER=$((GTIMECOUNTER+1))
   CPUTEMPCOUNTER=$((CPUTEMPCOUNTER+1))
   WEATHERCOUNTER=$((WEATHERCOUNTER+1))

   sleep $INTERVAL
done
