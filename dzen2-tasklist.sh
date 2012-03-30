#!/bin/sh
# Title:    dzen-tasklist.sh
# Author:   gladstone
# Version:  1.1.4 (2009-06-09)
# Source:   http://linsovet.com/content/xmonad-dzen-task-list-menu
# Depends:  dzen, wmctrl, gawk
#
# A dzen tasklist. Left-clicking on a menu item switches to the running
# apps workspace.
#   Add:
#        -fn $FONT
# if your dzen is compiled with XFT support.
#
# TODO:
# * Menu items display could be more pretty
# * Mousewheel to switch between items?
# * Once ran, how can new items be added to the list?

WHEREX="0"
WIDTH="500"
#FONT="-*-dejavu sans-medium-r-normal-*-9-*-*-*-*-*-*-*"
FG="#aaaaaa"
BG="#1a1a1a"

(echo "Task List"; wmctrl -l) | \
    dzen2 \
        -m -p -l 15 -x $WHEREX  -w $WIDTH -fg $FG -bg $BG -e \
'button1=menuprint;button3=exit;entertitle=uncollapse;leaveslave=collapse' | \
    awk '{system("wmctrl -s " $2)}'
