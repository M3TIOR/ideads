#!/usr/bin/make

# M3TIOR 2017
#
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
override FILE := $(lastword $(subst /, ,$(FILE_RELATIVE)))
override PATH_RELATIVE := $(subst $(FILE),,$(FILE_RELATIVE))
override PATH_ABSOLUTE := $(FILE_ABSOLUTE:/$(FILE)=)
override TMP := $(shell \
	if type mktemp > /dev/null 2>&1; then\
		if mktemp -d --quiet; then\
			return 0;\
		fi;\
	fi;\
	mkdir -p $(PATH_ABSOLUTE)/.tmp;\
	echo $(PATH_ABSOLUTE)/.tmp;\
)
$(shell echo "$(TMP)" >> $(PATH_ABSOLUTE)/.tmplist)

include $(PATH_ABSOLUTE)/tools/metachar.mk
include $(PATH_ABSOLUTE)/tools/gnu-std.mk


# NOTE: GNU-STD deviation;
#	I'm the type of person who crave's reproducibilty.
#	So I'm enforcing a strict law that all files must be
#	built en stage, before being installed.
#
#	This way users are also able to test an app in one location
#	to see if it's to their liking before actually installing it on
#	their machine.
stage := $(PATH_ABSOLUTE)/BUILD
srcdir := $(PATH_ABSOLUTE)/src

# NOTE:
# 	this is placed here to ensure all the build directories already exist
#	before we try and do anything stupid, ex: putting shit where it needs to go.
# 	it's used within the 'init' recipie
override DIRS	= $(prefix) $(exec_prefix) $(bindir) $(sbindir) $(libexecdir) \
				$(datarootdir) $(datadir) $(sysconfdir) $(sharedstatedir) \
				$(localstatedir) $(runstatedir) $(includedir) $(oldincludedir) \
				$(docdir) $(infodir) $(htmldir) $(dvidir) $(pdfdir) $(psdir) \
				$(libdir) $(lispdir) $(localedir) $(mandir) $(uninstallerdir)
$(shell \
	for path in $(DIRS); do \
		mkdir -p $(stage)$$path; \
	done;\
)


# Main segment of script:
# 	This line is here to provide the local filename for use in building the recipies
# 	this way there's less redundant typing also opening the facility of using
#
#	make <package>
#
# 	for building packages easier...
override PACKAGE = $(subst .mk,,$(lastword $(subst /,$(SPACE),$(lastword $(MAKEFILE_LIST)))))
# TODO: XXX FIXME XXX
#override INITPKG = \
#$(PACKAGE): ;\
#	$(if ($(debug), $(EMPTY)),\
#		$(subst $(NEWLINE),,\
#			$(bake)\
#		),\
#		$(subst $(NEWLINE),@,\
#			@$(bake)\
#		)\
#	)
#
# 	This finds packages so we can try and build them
# 	Strips the containing directory and trims off the file extension,
#	all for easier usage in the help, list and all step
override packages := $(wildcard $(PATH_ABSOLUTE)/tools/package/*.mk)
override targets := \
	$(foreach target,$(packages),\
		$(subst .mk,$(EMPTY),\
			$(lastword $(subst /,$(SPACE),$(target)))\
		)\
	)


# as the default, make only builds the projects
# XXX: borked, seriously this syntax is killer...
#		for some reason this won't work if you add whitespace before
#		a comment. I'm assuming what's happening is the variable is being
#		saved with the trailing whitespace... It should trim... ugh...

export mode := build
export savetemp ?=
export debug ?=


#----------------------------------------------------------------------
# Phony targets don't output files
.PHONY: help clean list $(targets)

help: list ;
	@ echo "To build individual packages:"
	@ echo "\t'make <package> <package2> ...'"
	@ echo "or, to build everything:"
	@ echo "\tmake all"
	@ echo "if you wish to install, uninstall, purge, fix, or reinstall a package"
	@ echo "\t'make mode='MODE' <package> ...' Where MODE is one of:"
	@ echo "\t\tbuild\n\t\tinstall"
	@ echo "\t\tpurge\n\t\tuninstall\n\t\treinstall"
	@ echo "\t\ttest\n\t\tdeb\n\t\tarchive\n\t\ttarball\n\t\t<custom>..."

list: ;
	@ echo "The current packages available for install in this repository are..."
	@ for package in $(targets); do \
		if [ "$${package%%debug.*}" ]; then \
			echo "\t$$package"; \
		fi; \
	done;

all: $(targets); @ # Build Everything

clean:
	@ # This just reads mtab for mouted directories within the jail
	@ # and unmounts them. Because I really don't want to kill my OS
	@ # By accident again...
	@ while read line; do \
		set - $$line; \
		if [ "$${2##$(PATH_ABSOLUTE)/BUILD*}" = '' ]; then \
			if ! umount $$2; then exit 1; fi; \
		fi; \
	done < /etc/mtab;
	@ rm -vrf $(PATH_ABSOLUTE)/BUILD;
	@ if [ -e $(PATH_ABSOLUTE)/.tmplist ]; then \
		while read file; do \
			rm -vrf $$file; \
		done < $(PATH_ABSOLUTE)/.tmplist; \
		rm $(PATH_ABSOLUTE)/.tmplist; \
	fi;
	@ echo "Clean!";

# this line loads in all the other sub-scripts
include $(packages)

# Clean up extra mounted directories after execution as a cautionary measure
$(shell \
	while read line; do \
		set - $$line; \
		if [ "$${2##$(PATH_ABSOLUTE)/BUILD*}" = '' ]; then \
			if ! umount $$2; then exit 1; fi; \
		fi; \
	done < /etc/mtab; \
)

# Clean up temporary folders and files when we don't need them saved
ifndef savetemp
$(shell \
	if [ -e $(PATH_ABSOLUTE)/.tmplist ]; then \
		while read file; do \
			rm -vrf $file; \
		done < $(PATH_ABSOLUTE)/.tmplist; \
		rm $(PATH_ABSOLUTE)/.tmplist; \
	fi; \
)
endif
