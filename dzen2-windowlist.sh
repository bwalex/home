#!/bin/sh
while true
do
    IFS=$'\n'
    echo -n "| "
    for window in $(wmctrl -l | grep " [0-9]* " | sed "s|\(.*\)  [0-9] $(hostname) \([a-zA-Z /0-9\-]*\)|\1////\2|")
    do
        id=$(echo $window | sed "s|\(.*\)////.*|\1|")
        name=$(echo $window | sed "s|.*////\(.*\)|\1|")
        echo -n "^ca(1,wmctrl -i -a ${id})${name}^ca()  | "
    done
    echo
    sleep 1
done
