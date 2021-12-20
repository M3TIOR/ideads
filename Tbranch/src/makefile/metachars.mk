#!/usr/bin/make

# M3TIOR 2017
#	This file declares some usefull metacharacters for use really anywhere
#	in makefile. Infact some things aren't even possible without these, like
#	private multiline variables.
#
#	It's not optimal for each situation however, and most times is best just
#	for code readability.
#

override DOUBLEQUOTE := "
# Use cases:
#

override SINGLEQUOTE := '
# Use cases:
#

override COMMA := ,
# Use cases:
#	* string substitution

override EMPTY :=
# Use cases:
#	* ***see below***

override SPACE := $(EMPTY) $(EMPTY)
# Use cases:
#	* readability


override TAB := $(EMPTY)	$(EMPTY)
# Use cases:
#	* readability

# -------------------------
override define NEWLINE :=


endef
# XXX: this must have two lines to function properly!!!
#
# Use cases:
#	* multiline variables
#	* recipie templating
# -------------------------
