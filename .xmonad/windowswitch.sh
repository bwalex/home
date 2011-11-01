#!/bin/sh

target=$(sh ~/.xmonad/windowlist.sh | dmenu)

if [ "$?" == "0" ]; then
  wmctrl -a $target
fi
