#!/usr/bin/make

# M3TIOR 2017
#	This is an interactive example file demonstrating all the
#	immediate, simple benefits of metacharacters.
#

# NOTE: PATH AND FILE REFFERENCES
override FILE_RELATIVE := $(lastword $(MAKEFILE_LIST))
override FILE_ABSOLUTE := $(abspath $(FILE_RELATIVE))
override FILE := $(lastword $(subst /, ,$(FILE_RELATIVE)))
override PATH_RELATIVE := $(subst $(FILE),,$(FILE_RELATIVE))
override PATH_ABSOLUTE := $(FILE_ABSOLUTE:/$(FILE)=)

include $(PATH_ABSOLUTE)/../metachars.mk

all: intro goodcomma badcomma

help: ;
	@echo "Examples:"
	@echo "\tgoodcomma: how to properly use commas within macros"

.PHONY: intro goodcomma badcomma

intro: ;
	# Metacharacters:
	#
	#	This interactive lesson goes through some usecases
	#	for metacharacters. Also, Things that can't happen without them
	#
	@echo
	@read -p "<Press Enter to Continue>" line
	@echo
	@echo

# Just some common vocabulary I use daily.
csv = stuff,otherstuff,derp,lol
goodcomma: ;
	# The line:
	# echo $$(subst $$(COMMA),$$(SPACE),$$(things))
	#
	# is correct syntax for makefile and outputs:
	@echo
	@echo $(subst $(COMMA),$(SPACE),$(things))
	@echo
	@read -p "<Press Enter to Continue>" line
	@echo
	@echo

badcomma: ;
	# Where as the line:
	# echo $$(subst ,, ,$$(things))
	#
	# Is incorrect and yeilds an error when tried:
	@echo
	@echo $$(subst ,, ,$$(things))
	@echo
	@read -p "<Press Enter to Continue>" line
	@echo
	@echo
