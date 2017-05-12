#!/bin/sh

export LC_CTYPE="en_US.UTF-8"

# causes problems on XFCE. Use for cwm only
#xrdb -merge .Xdefaults

# necessary only on cwm
#xconsole -geometry -2-2 -fn 5x7 &
#xclock -digital -brief -geometry -0+0 &
#xsetroot -solid steelblue &

setxkbmap -option 'grp:win_space_toggle' 'us,sk' -variant ',qwerty'

# WM of choice
#cwm
/usr/local/bin/startxfce4 --with-ck-launch
