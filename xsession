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

# for this to work you must have the following in
# /usr/share/xsessions/xsession.desktop:

#    [Desktop Entry]
#    Name=Awesome-Gnome
#    Comment=This runs ~/.xsession
#    Exec=/etc/X11/Xsession
