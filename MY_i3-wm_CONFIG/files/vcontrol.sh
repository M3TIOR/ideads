#!/bin/sh
#M3TIOR 2015

if ! [ -e ~/.i3/settings/volume ]; then
	echo "50" > ~/.i3/settings/volume;
fi

v=$(cat ~/.i3/settings/volume);
case $1 in
	"up")
		v=$(( $v + 5 ));
		if [ $v -gt 100 ]; then
			v=100;
		fi
		echo "volume increased; v=$v"
		pactl set-sink-volume 0 "$v%";
	;;
	"down")
		v=$(( $v - 5 ));
		if [ $v -lt 0 ]; then
			v=0;
		fi
		echo "volume lowered; v=$v"
		pactl set-sink-volume 0 "$v%";
	;;
	"mute")
		v=0;
		pactl set-sink-volume 0 "$v%";
	;;
esac
echo $v > ~/.i3/settings/volume;
