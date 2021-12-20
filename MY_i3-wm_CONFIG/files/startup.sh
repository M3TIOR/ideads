#!/bin/sh
#M3TIOR 2016

while read line; do
	#cuts the first letter out of the input line and tests for comments
	x=$(echo $line | sed "s/.//2g");
	if [ "$x" != "#" ]; then
		#executes the line if it's not a comment
		d=$(date)
		echo "$date $line ---"
		sh -c "$line" 2>> ~/.i3/settings/debug.log &
	fi
done < ~/.i3/settings/onload

