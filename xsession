nm-applet &
dropbox start &
xautolock -time 5 -locker lock-now &
eval `gnome-keyring-daemon`
eval `ssh-agent`
eval `gpg-agent --daemon -s --default-cache-ttl 28800 --max-cache-ttl 86400`
taffybar &
xmodmap "$HOME/.xmodmap"
keepassx &
sv-run-offlineimap &
scenery &
armstrong &
postqueue-checker &

exec xmonad
# vim: ft=sh
