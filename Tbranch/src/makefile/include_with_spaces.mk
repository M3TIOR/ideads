
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


override a = $(eval include $(subst $(SPACE),\\ ,$(1)))

# NOTE: PATH AND FILE REFFERENCES
override FILE_RELATIVE := $(lastword $(MAKEFILE_LIST))
override FILE_ABSOLUTE := $(abspath $(FILE_RELATIVE))
override FILE := $(lastword $(subst /, ,$(FILE_RELATIVE)))
override PATH_RELATIVE := $(subst $(FILE),,$(FILE_RELATIVE))
override PATH_ABSOLUTE := $(FILE_ABSOLUTE:/$(FILE)=)

include $(call a,$(PATH_ABSOLUTE)/tests/with\ spaces\ in\ it/var.mk)

default:
	echo "$(derp)";
