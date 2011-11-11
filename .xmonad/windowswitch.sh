#!/bin/bash

target=$(sh ~/.xmonad/windowlist.sh | dmenu)

if [ "$?" == "0" ]; then
  wmctrl -i -a $target
fi
