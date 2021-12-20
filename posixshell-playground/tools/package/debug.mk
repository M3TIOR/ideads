#!/usr/bin/make

# M3TIOR 2017
#	NOTE: this is a testing package for the m3tior.mk toolkit
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

# init a new temp folder specific to this package
$(shell mkdir -p $(TMP)/template.sh)

private $(PACKAGE) : build := \
	\# I'm gonna make a few test files here... $(NEWLINE)\
	printf "\#\041/bin/sh\n\necho 'test \#1'" > $(stage)$(bindir)/test1 $(NEWLINE)\
	printf "\#\041/bin/sh\n\necho 'test \#2'" > $(stage)$(sbindir)/test2 $(NEWLINE)\
	printf "\#\041/bin/sh\n\necho 'test \#3'" > $(stage)$(mandir)/test3 $(NEWLINE)\
	printf "\#\041/bin/sh\n\necho 'test \#4'" > $(stage)$(includedir)/test4 $(NEWLINE)\
	printf "\#\041/bin/sh\n\necho 'test \#5'" > $(stage)$(datadir)/test5 $(NEWLINE)\
	printf "\#\041/bin/sh\n\necho 'test \#6'" > $(stage)$(libdir)/test6 $(NEWLINE)


private $(PACKAGE) : mkuninstaller := \
	$(ENV_m3tior_mkuninstaller)

private $(PACKAGE) : install := \
	# Break things here so nothing gets done for now... $(NEWLINE)\
	$(ENV_m3tior_mkuninstaller) $(NEWLINE)\
	$(ENV_m3tior_install) $(NEWLINE)

private $(PACKAGE) : uninstall := \
	$(ENV_m3tior_uninstall)

private $(PACKAGE) : reinstall := \
	#NOT IMPLEMENTED

private $(PACKAGE) : purge := \
	#NOT IMPLEMENTED

private $(PACKAGE) : deb := \
	#NOT IMPLEMENTED

private $(PACKAGE) : tarball := \
	#NOT IMPLEMENTED

private $(PACKAGE) : archive := \
	#NOT IMPLEMENTED

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

$(eval private $(PACKAGE): bake := $$($(mode)))
$(PACKAGE): ;
ifneq ($(debug), $(EMPTY))
	$(bake)
else
	$(subst $(NEWLINE),$(NEWLINE)@,\
		@$(bake)\
	)
endif
