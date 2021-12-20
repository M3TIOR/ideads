#!/usr/bin/make

# M3TIOR 2017
#	This file declares some usefull metacharacters for use really anywhere
#	in makefile. Infact some things aren't even possible without these, like
#	private multiline variables.
#

# XXX: META-characters
override HASHTAG := \#
override $(HASHTAG) := \#

override ATYSYMBOL := @
override COMMA := ,
override EMPTY :=
override SPACE := $(EMPTY) $(EMPTY)
override TAB := $(EMPTY)	$(EMPTY)
override define NEWLINE :=


endef
#
# XXX: this must have two lines to function properly!!!
#
