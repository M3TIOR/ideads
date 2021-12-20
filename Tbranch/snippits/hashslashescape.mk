#!/usr/bin/make

# M3TIOR 2017
#
#

HASHTAG := \#
override ATSYMBL := @

STRING := #does this work?
STRINGESC := \#$(STRING)
$(HASHTAG) := test
$(ATSYMBL) := things

main: ;
	echo "$(STRING)"
	echo "$(STRINGESC)"
	echo "$(#)"
	echo "$(ATSYMBL)"
