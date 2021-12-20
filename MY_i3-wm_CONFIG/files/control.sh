#!/bin/sh
#M3TIOR 2016

i3DIR="~/.i3";
SETTINGSDIR="$i3DIR/settings.d";

# So starting today, I'm trying to unify the heap of small things into a larger
# file that will keep our ram and disk usage to a minimum. Starting a bunch of
# sepperate shell sessions is going to get extremely redundant evenutally. So
# this is the file where all of our code is going to go.

#debug redirection unit.
log(){
	echo "$(date):$*"
}

#get and set settings from file by name.
import(){
        echo $(cat $SETTINGSDIR/$1);
}
export(){
        echo $2 > $SETTINGSDIR/$1;
}

gender(){
        #generates defaults if they don't exist
        if ! [ -e $SETTINGSDIR/$1 ]; then
        	echo "$2" > $SETTINGSDIR/$1;
        fi
}

# I tried to do a thing and failed (;-;)
# don't wanna waste time to commit it...
# shame, it was a 100 line blob of oop junk. XP

#controllers:
lcontrol(){
        #backlight controller#
        local v=$(import backlight)
        case "$*" in
        	"up")
        		local v=$(( $v + 10 ));
        		if [ $v -gt 100 ]; then
        			local v=100;
        		fi
        		xbacklight -set $v;
                        log "Backlight dimmed; @$v";
        	;;
        	"down")
        		local v=$(( $v - 10 ));
        		if [ $v -lt 0 ]; then
        			local v=0;
        		fi
        		xbacklight -set $v;
                        log "Backlight dimmed; @$v";
        	;;
        esac
        export backlight $v;
}
vcontrol(){
        #volume controller#
        local v=$(import volume);
        case $* in
        	"up")
        		local v=$(($v + 5));
        		if [ $v -gt 100 ]; then
        			local v=100;
        		fi
        		pactl set-sink-volume 0 "$v%";
                        log "Volume raised; @$v";
        	;;
        	"down")
        		local v=$(($v - 5));
        		if [ $v -lt 0 ]; then
        			local v=0;
        		fi
        		pactl set-sink-volume 0 "$v%";
                        log "Volume decreased; @$v";
        	;;
        	"mute")
        		local v=0;
        		pactl set-sink-volume 0 "$v%";
                        log "Volume muted; @$v";
        	;;
        esac
        export volume $v
}

gender backlight 100
gender volume 50
gender debug.redirect "/var/log/i3/debug.log"


for arg in $*; do
        case $arg in
                volume)
                        shift;
                        vcontrol $1;
                ;;
                backlight)
                        shift;
                        lcontrol $1;
                ;;
                *)
                        log "Bad argument; @$arg";
                ;;
done;
#exit
