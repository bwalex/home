#!/bin/bash
#
# (c) 2007 by Robert Manea
#
# Left mouse button toggles detailed view
# Right mouse button quits

#--[ Configuration ]---------------------------------------------------

# bg color
#BG='#494b4f'
BG='#000000'
# fg color
FG='grey70'
# font
FNT2='Monospace'
FNT2='Terminus'
# x position
XPOS=$1
# y position
YPOS=0
# title width
TWIDTH=280
# details area width
DWIDTH=280

# events & actions
ACT='button1=togglecollapse;button3=exit'

#----------------------------------------------------------------------

#!/bin/bash
#
# pop-up calendar for dzen
#
# (c) 2007, by Robert Manea
# 

while (
TODAY=$(expr `date +'%d'` + 0)
MONTH=`date +'%m'`
YEAR=`date +'%Y'`

echo  -n '^tw()^bg(grey70)^fg(#111111)'
date +'%A, %d.%m.%Y %H:%M:%S'

# current month, highlight header and today
cal -h | sed -r -e "1,2 s/.*/^fg(white)&^fg()/" \
             -e "s/(^| )($TODAY)($| )/\1^bg(white)^fg(#111)\2^fg()^bg()\3/"

# next month, hilight header
[ $MONTH -eq 12 ] && YEAR=`expr $YEAR + 1`
cal -h `expr \( $MONTH \) % 12 + 1` $YEAR \
    | sed -e "1,2 s/.*/^fg(white)&^fg()/"
#echo ''
); do
sleep 1
done | dzen2 -ta l -fn $FNT2 -h 16 -x $XPOS -y $YPOS -tw $TWIDTH -w $DWIDTH -l 16 -sa c -e $ACT
