#!/bin/sh
#M3TIOR 2016

if ! [ -e ~/.i3/settings/light ]; then
	echo "100" > ~/.i3/settings/light;
fi

v=$(cat ~/.i3/settings/light);
case "$1" in
	"up")
		v=$(( $v + 10 ));
		if [ $v -gt 100 ]; then
			v=100;
		fi
		echo "v = $v;"
		xbacklight -set $v;
		echo "Backlight Brightened"
	;;
	"down")
		v=$(( $v - 10 ));
		if [ $v -lt 0 ]; then
			v=0;
		fi
		echo "v = $v"
		xbacklight -set $v;
		echo "Backlight Dimmed"
	;;
esac
echo $v > ~/.i3/settings/light
