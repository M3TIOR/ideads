#!/usr/bin/make

# CONTRIBUTOR CREDIT LINE
#	notes...
#

# <recipe> should be the name of the package you're making in this repo
# <ingredients> are any files that need to exist for this package to be made
#
#	the recipie's directions are up to you.
#

# mode ?= build			# this line is always assumed to exist
#						# subsequent modes cand be any of...
#
#	build 		- builds the project and outputs it to the repo/BUILD directory
#	install 	- builds and installs the project to it's designated location
#	uninstall 	- removes all files built in with the project
#	reinstall	- uninstalls, builds and installs the package
#	purge		- removes all files associated with the project including those
#				  in user configuration directories
#	deb			- outputs the built project as a .deb package
#	tarball 	- outputs the built project as a .tar archive
#	archive		- outputs the built project as a .ar archive (gnu-make's builtin)
#	test		- runs all tests for the project
#

# It's recommended that you 'can' each of the build modes and use a conditional
# within the actual recipie statement.
#
# for help on canning: https://www.gnu.org/software/make/manual/make.html#Canned-Recipes
#
# UPDATE: XXX
#	Local 'canning' isn't a functional part of the makefile syntax so to make
#	things debuggable, use multiline local variables in place of local cans
#	a metacharacter called $(NEWLINE) exists as a line terminator so we can
#	do exactly this. However, be aware this variable is inherited from the core
#	makefile in the root.
#
#	Example:
#
#		private recipie : <mode> := \
#			@ command $(NEWLINE) \ 	# don't forget that each subsequent
#			@ for each in: do \		# line must be escaped to be a proper part
#				commands \			# of the mode since it's being directly
#			done; $(NEWLINE)\		# inserted into the recipie
#			\
#			@ other_command...		# and that the final line shouldn't be escaped
#
#


# The lines:
#	PATH_ABSOLUTE := <relative path to the main script>
#	TMP := <path to temporary file storage location>
#	PACKAGE := <this file's name>
#
# 	should always be presumed to exist, since this makefile is loaded
# 	externally from the main repository makefile and can be used to
# 	address files within the repo.

# This line is here to provide the local filename for use in building the recipies
# this way there's less redundant typing also opening the facility of using
#
#	make <package>
#
# for building packages easier...
$(shell mkdir -p $(TMP)/template.sh) # init a new temp folder specific to this package

private $(PACKAGE) : build := \
	$(#) NOT IMPLEMENTED

private $(PACKAGE) : install := \
	$(#) NOT IMPLEMENTED

private $(PACKAGE) : uninstall := \
	$(#) NOT IMPLEMENTED

private $(PACKAGE) : reinstall := \
	$(#) NOT IMPLEMENTED

private $(PACKAGE) : purge := \
	$(#) NOT IMPLEMENTED

private $(PACKAGE) : deb := \
	$(#) NOT IMPLEMENTED

private $(PACKAGE) : tarball := \
	$(#) NOT IMPLEMENTED

private $(PACKAGE) : archive := \
	$(#) NOT IMPLEMENTED

private $(PACKAGE) : test := \
	$(#) NOT IMPLEMENTED

# NOTE:
#	On building tests... Each test should be hosted within a chroot of the
#	build directory with a symbolic link to the root directory for linking purposes.
#	all projects in this repo should be able to stand on it's own two feet with it's
#	dependencies
#
#	example:
#		@ mkdir -p $(srcdir)/BUILD/shadowroot; $(NEWLINE)\
#		@ mount -o bind,ro / $(srcdir)/BUILD/shadowroot; $(NEWLINE)\
#		TEST='
#
#		';\ # Can't have a newline here because we need to pass TEST
#		chroot '$(srcdir)/BUILD/' "sh -i
#
# NOTE: WARNING!!!
#	Please for the love of god don't forget the --read-only / -o ro,...
#	I killed my last OS three days ago because of that... I tried to rm -rf the
#	BUILD directory while I had unprotected mounts to root open... (;-;)
#

# NOTE: WARNING; DO NOT REMOVE!
#	For now, the content below this is going to be manditory for
#	packages to contain. I may be replacing this with a prototype variable
#	in the near future, but for now I can't get the syntax to work correctly
#
$(eval private $(PACKAGE): bake := $$($(mode)))
$(PACKAGE): ;
	@ # Debugging Controller...
	@ # If you wish to see each line executed simply use:
	@ #
	@ #		make recipie ... debug=true
	@ #
ifneq ($(debug), $(EMPTY))
	$(bake)
else
	$(subst $(NEWLINE),$(NEWLINE)@,\
		@$(bake)\
	)
endif
