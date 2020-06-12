#!/bin/sh

echo "Starting xsession: $(date)"

systemctl --user daemon-reload
systemctl --user start poller
systemctl --user start sound

# this thing prints a ton of stupid GTK warnings
nm-applet >/dev/null 2>&1 &
dropbox start &
xautolock -time 5 -locker lock-now -corners +0-0 &
xset dpms 120
eval `gnome-keyring-daemon`
eval `ssh-agent`
test -f $HOME/code/unproductive/bin/unproductive &&
   $HOME/code/unproductive/bin/unproductive >> $HOME/activity-log.txt &
setmyxkbmap
keepassxc &
scenery &
armstrong &
postqueue-checker &

# flameshot doesn't like to start before the bar is ready, so start it much later, just in case.
( sleep 30; flameshot ) &

exec awesome
