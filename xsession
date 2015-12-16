nm-applet &
dropbox start &
xautolock -time 5 -locker 'i3lock -c black -d -I 2 -e' &
eval `gnome-keyring-daemon`
eval `ssh-agent`
eval `gpg-agent --daemon -s --default-cache-ttl 28800 --max-cache-ttl 86400`
xmodmap "$HOME/.xmodmap"
keepassx &
sv-run-w.pl &
sv-run-offlineimap &
armstrong &

exec awesome
# vim: ft=bash
