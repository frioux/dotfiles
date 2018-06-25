#!/bin/sh

echo "Starting xsession: $(date)"

systemctl --user daemon-reload
systemctl --user start poller
systemctl --user start sound

nm-applet &
dropbox start &
xautolock -time 5 -locker lock-now &
eval `gnome-keyring-daemon`
eval `ssh-agent`
test -f $HOME/code/unproductive/bin/unproductive &&
   $HOME/code/unproductive/bin/unproductive >> $HOME/activity-log.txt &
taffybar &
xmodmap "$HOME/.xmodmap"
keepassxc &
sv-run-offlineimap &
scenery &
armstrong &
postqueue-checker &
shutter --min_at_startup &

exec xmonad
