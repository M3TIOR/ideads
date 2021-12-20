#!/usr/bin/make

# CREATOR YEAR
#
#	NOTE: about the makefile
#

# NOTE:
#	Because some essential variables exist, I need a facility to make
#	them more prominent than standard variables. so (very complex much wow)
#	I'm just making all of them UPPERCASE horray right! so easy to read!
#	also it's less likely you'll accidentally name a variable like it since
#	most people don't like to type with caps-lock on.
#

# NOTE: PATH AND FILE REFFERENCES
override FILE_RELATIVE := $(lastword $(MAKEFILE_LIST))
override FILE_ABSOLUTE := $(abspath $(FILE_RELATIVE))
override FILE := $(lastword $(subst /,$(SPACE),$(FILE_RELATIVE)))
override PATH_RELATIVE := $(subst $(FILE),,$(FILE_RELATIVE))
override PATH_ABSOLUTE := $(FILE_ABSOLUTE:/$(FILE)=$(EMPTY))

# XXX: META-characters
override COMMA := ,
override EMPTY :=
override SPACE := $(EMPTY) $(EMPTY)
override define NEWLINE :=


endef
#
# XXX: this must have two lines to function properly!!!
#


# Phony targets don't output files
.PHONY: build install package purge uninstall reinstall clean

# If no parameter is specified, then the first listed option is built first
# We always want to build the project before deciding on installing it
build: dependencies
	#location/to/build/script

install: build
	#location/to/install/script

package: build
	#location/to/package-builder/script

uninstall:
	#location/to/uninstall/script

reinstall: uninstall install;

fix: purge install;

purge:
	#location/to/purge/script

clean:
	@rm -vrf $(PATH_ABSOLUTE)/BUILD
	@echo "Clean!"
