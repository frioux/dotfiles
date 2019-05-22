#!/bin/sh

echo "Starting xsession: $(date)"

systemctl --user daemon-reload
systemctl --user start poller
systemctl --user start sound

nm-applet &
dropbox start &
xautolock -time 5 -locker lock-now &
xset dpms 120
eval `gnome-keyring-daemon`
eval `ssh-agent`
test -f $HOME/code/unproductive/bin/unproductive &&
   $HOME/code/unproductive/bin/unproductive >> $HOME/activity-log.txt &
xmodmap "$HOME/.xmodmap"
keepassxc &
sv-run-offlineimap &
scenery &
armstrong &
postqueue-checker &
flameshot &

exec awesome
