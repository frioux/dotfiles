nm-applet &
dropbox start &
uptrack-manager &
$HOME/bin/remind-daemon &
eval `gnome-keyring-daemon`
eval `ssh-agent`
eval `gpg-agent --daemon -s`
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
