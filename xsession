nm-applet &
dropbox start &
uptrack-manager &
xscreensaver -no-splash &
$HOME/bin/remind-daemon &
eval `gnome-keyring-daemon`
eval `ssh-agent`
eval `gpg-agent --daemon -s --default-cache-ttl 28800 --max-cache-ttl 86400`
xmodmap "$HOME/.xmodmap"
keepassx &

exec awesome
# vim: ft=bash
