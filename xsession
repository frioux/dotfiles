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
taffybar &
xmodmap "$HOME/.xmodmap"
keepassxc &
sv-run-offlineimap &
scenery &
armstrong &
postqueue-checker &
shutter --min_at_startup &

exec xmonad
