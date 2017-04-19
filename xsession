nm-applet &
dropbox start &
xautolock -time 5 -locker lock-now &
eval `gnome-keyring-daemon`
eval `ssh-agent`
eval `gpg-agent --daemon -s --default-cache-ttl 28800 --max-cache-ttl 86400`
trayer --edge top --align right --SetDockType true --SetPartialStrut true \
   --expand true --widthtype pixels --width 288 --height 24 --transparent true --tint 0x000000 &
xmodmap "$HOME/.xmodmap"
keepassx &
sv-run-offlineimap &
scenery &
armstrong &
postqueue-checker &

stats | dzstats &

exec xmonad
# vim: ft=sh
