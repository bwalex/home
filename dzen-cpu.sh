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
FNT='-*-profont-*-*-*-*-11-*-*-*-*-*-iso8859'
# x position
XPOS=$1
# y position
YPOS=0
# title width
TWIDTH=80
# details area width
DWIDTH=150

# events & actions
ACT='button1=togglecollapse;button3=exit'

#----------------------------------------------------------------------

gcpubar -l '^i(/home/alex/dzen_bitmaps/cpu16.xpm)' -fg '#aecf96' -bg '#37383a' -w 50 -h 7 | dzen2 -h 16 -ta l -fn $FNT -bg $BG -fg $FG -x $XPOS -y $YPOS -tw $TWIDTH -w $DWIDTH -sa c -e $ACT
