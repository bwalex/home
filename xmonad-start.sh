#!/bin/bash

xrdb -merge .Xresources

## test for an existing bus daemon, just to be safe
if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
    ## if not found, launch a new one
    eval `dbus-launch --sh-syntax --exit-with-session`
#    echo "D-Bus per-session daemon address is: $DBUS_SESSION_BUS_ADDRESS"
fi


trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 15 --height 12 --transparent true --tint 0x000000 &

#dbus-launch gnome-keyring-daemon --start --components=pkgcs11,secrets,ssh,gpg &

if [ -x /usr/lib/gnome-settings-daemon/gnome-settings-daemon ]; then
   dbus-launch /usr/lib/gnome-settings-daemon/gnome-settings-daemon &
fi

if [ -x /usr/bin/gnome-power-manager ] ; then
   dbus-launch gnome-power-manager &
fi

if [ -x /usr/bin/nm-applet ] ; then
   dbus-launch nm-applet --sm-disable &
fi

dbus-launch gnome-volume-control-applet &

#exec ck-launch-session dbus-launch /home/alex/.cabal/bin/xmonad
exec dbus-launch /home/alex/.cabal/bin/xmonad
