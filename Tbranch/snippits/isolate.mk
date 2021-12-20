#!/usr/bin/make

#
# M3TIOR 2018
#

# NOTE: PATH AND FILE REFFERENCES
override FILE_RELATIVE := $(lastword $(MAKEFILE_LIST))
override FILE_ABSOLUTE := $(abspath $(FILE_RELATIVE))
override FILE := $(lastword $(subst /, ,$(FILE_RELATIVE)))
override PATH_RELATIVE := $(subst $(FILE),,$(FILE_RELATIVE))
override PATH_ABSOLUTE := $(FILE_ABSOLUTE:/$(FILE)=)
override define NEWLINE :=


endef
#
# XXX: this must have two lines to function properly!!!
#

.SHELL: bash

ifneq ($(shell pwd), $(PATH_ABSOLUTE))
$(firstword $(MAKECMDGOALS)): ;\
	$(MAKE) -f $(FILE_ABSOLUTE) --directory $(PATH_ABSOLUTE) \
	$(foreach flag,$(MAKEFLAGS),-$(flag)) $(MAKECMDGOALS); $(NEWLINE)
$(foreach target,$(subst $(firstword $(MAKECMDGOALS)),,$(MAKECMDGOALS)),$(strip \
	$(target): ;$(NEWLINE)\
		printf "";\
))
################################################################################
.PHONY: test

test: ;
	echo $(FILE_ABSOLUTE)
	echo $(PATH_ABSOLUTE)
	pwd
################################################################################
endif



#$(foreach target,$(MAKECMDGOALS),$(strip \
#	$(target): ;$(NEWLINE)\
#		$(MAKE) -f $(FILE_ABSOLUTE) --directory $(PATH_ABSOLUTE)\
#		$(foreach flag,$(MAKEFLAGS),-$(flag)) $(MAKECMDGOALS)\
#))
