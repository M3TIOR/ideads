#!/usr/bin/make

# M3TIOR 2017
#	This script tests a few more advanced features of the makefile language
#	 * Variable Templates
#	 * Recipie Templates
#	 * Nested Templates
#

all: variable-template recipie-template nested-template;

.PHONY: all variable-template recipie-template nested-template

#-------------------------------------------------------------------------------
# VARIABLE TEMPLATES

# The following is a variable template without anything too special.
# Just a definition with it's contents
variable-template = some $(1) contents for yaz. $(2) isn't it?
# NOTE:
#	variable template's won't function if "simply expanded"
#	they must be recursivly expanded for makefile to register
#	the existance of the argument calls.
#	See "**Variable Flavors***"
#
# Variable template's are especially usefull when you have a pattern
# that needs to be repeated a number of times with different inputs.

variable-template:
	echo $(call variable-template, terrible)
	@ read -p "<Press Enter to continue>" line;

#-------------------------------------------------------------------------------
# RECIPIE TEMPLATES

# Just like with regular variable definitions, we can also make templates
# that form recipies when expanded.
#
# For example:
recipie-template = $(1): $(2); $(3)

# We can the use to say:
$(call recipie-template,\
	recipie-template, ,@ echo "I'm a recipie!"; read -p "<Press Enter to continue>" line;)
