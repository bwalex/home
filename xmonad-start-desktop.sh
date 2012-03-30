#!/bin/bash

xrdb -merge .Xresources

## test for an existing bus daemon, just to be safe
if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
    ## if not found, launch a new one
    eval `dbus-launch --sh-syntax --exit-with-session`
#    echo "D-Bus per-session daemon address is: $DBUS_SESSION_BUS_ADDRESS"
fi


#trayer --edge top --align right --SetDockType true --expand true --width 15 --height 12 --transparent true --alpha 0 --tint 0x000000 &

tint2 &
#tint2 -c ~/.config/tint2/tint2rc.right &

#dbus-launch gnome-keyring-daemon --start --components=pkgcs11,secrets,ssh,gpg &

eval $(gnome-keyring-daemon --start)
export GNOME_KEYRING_SOCKET
export GNOME_KEYRING_PID

# Required for wallpaper, gtk themes, etc
gnome-settings-daemon &

if [ -x /usr/bin/nm-applet ] ; then
   dbus-launch nm-applet --sm-disable &
fi

gnome-volume-control-applet &

# Nice volume management and lightweight stuff
pcmanfm --desktop &

#seahorse-daemon

#exec ck-launch-session dbus-launch /home/alex/.cabal/bin/xmonad
exec dbus-launch xmonad
