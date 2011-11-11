#!/bin/bash
    cws=$(wmctrl -d | awk '/\*/ {print $1}')

    IFS=$(echo "")

    # build the windowlist
    for window in $(wmctrl -l | awk '/0x[0-9abcdef]+ +'$cws'/ {print}' | sed 's/\(0x[0-9abcdef]*\) *'$cws' *[^ ]* */\$\!\1\t/')
    do
	windowlist="$windowlist$window"
        i=$(($i + 1))
    done
    
    # print the windowlist, padding, date, and clock
    echo "$windowlist"

    # clear the windowlist
    windowlist=""
