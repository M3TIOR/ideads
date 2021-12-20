#!/usr/bin/make

# M3TIOR 2017
#	notes...
#

# <recipe> should be the name of the PACKAGE you're making in this repo
# <ingredients> are any files that need to exist for this PACKAGE to be made
#
#	the recipie's directions are up to you.
#

# mode ?= build			# this line is always assumed to exist
#						# subsequent modes cand be any of...
#
#	build 		- builds the project and outputs it to the repo/BUILD directory
#	install 	- builds and installs the project to it's designated location
#	uninstall 	- removes all files built in with the project
#	reinstall	- uninstalls, builds and installs the PACKAGE
#	purge		- removes all files associated with the project including those
#				  in user configuration directories
#	deb			- outputs the built project as a .deb PACKAGE
#	tarball 	- outputs the built project as a .tar archive
#	archive		- outputs the built project as a .ar archive (gnu-make's builtin)
#

# It's reccomended that you 'can' each of the build modes and use a conditional
# within the actual recipie statement.
#
# for help on canning: https://www.gnu.org/software/make/manual/make.html#Canned-Recipes

# The line:
#	PATH_ABSOLUTE := <relative path to the main script>
# should always be presumed to exist also, since this makefile is loaded
# externally from the main repository makefile and can be used to
# address files within the repo.
#

# This line is here to provide the local filename for use in building the recipies
# this way there's less redundant typing
$(shell mkdir -p $(TMP)/template.sh) # init a new temp folder specific to this PACKAGE

private $(PACKAGE) : build := \
	VERSION=$$(\
		git log --pretty=format:"%H" $(srcdir)/template.sh.php | while read version; do\
			echo $$version;\
			break;\
		done;\
	); \
	GLOBAL_PATH=$(datadir)/m3tior/template.sh; \
	php -f $(srcdir)/template.sh.php -- \
		--version="$$VERSION" \
		--global-data="$$GLOBAL_PATH" \
	> $(stage)/$(bindir)/template; $(NEWLINE)\
	mkdir -p $(stage)/$(datadir)/m3tior/template.sh; $(NEWLINE)\
	cp -rfu \
		$(foreach data,\
			$(filter-out $(addprefix $(PATH_ABSOLUTE)/res/template/, . ..) ,\
				$(wildcard $(addprefix $(PATH_ABSOLUTE)/res/template/, * .*)) \
			),\
			$(data) \
		) \
		$(stage)/$(datadir)/m3tior/template.sh;

private $(PACKAGE) : install := \
	#NOT IMPLEMENTED

private $(PACKAGE) : uninstall := \
	#NOT IMPLEMENTED

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

private $(PACKAGE) : test := \
	#NOT IMPLEMENTED


$(eval private $(PACKAGE): bake := $$($(mode)))
$(PACKAGE): ;
ifneq ($(debug), $(EMPTY))
	$(bake)
else
	$(subst $(NEWLINE),$(NEWLINE)@,\
		@$(bake)\
	)
endif
