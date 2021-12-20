#!/usr/bin/make

# M3TIOR
#	My personal standards file.
#	This contains every macro I use for building configuration scripts.
#

# NOTE: GNU-STD deviation
uninstallerdir	:= $(sysconfdir)/m3tior/uninstall

override ENV_m3tior_mkuninstaller = \
	@ \
	printf '\
		\#\041/bin/sh\n\
		\n\# M3TIOR\'s Generated Shell Uninstaller v0.1\n\
		\nFILES= \'\';\
		\n' > $(TMP)/template.sh/uninstall.sh $(NEWLINE)\
	@ \
	mkdir -p $(TMP)/template.sh/installtracker $(NEWLINE)\
	@ \
	cp --attributes-only -rfuv $(wildcard $(srcdir)/BUILD/*)\
		$(TMP)/template.sh/installtracker >> $(TMP)/template.sh/tracker.log; $(NEWLINE)\
	@ \
	while read line; do\
		echo "$line" >> /dev/null;\
		SORC=${line# -> *};\
		echo "$SORC" >> /dev/null;\
		DEST=${line%* -> }
		echo "$DEST" >> /dev/null;\
	done < $(TMP)/template.sh/tracker.log;

override ENV_m3tior_install = \
	@ \
	cp -rfuv $(wildcard $(prefix)/BUILD/*) / >> $(TMP)/template.sh/install.log; \
	@ \
	while read line; do\
		echo "test";\
	done < $(TMP)/template.sh/install.log;

override ENV_m3tior_uninstall = \
	#NOT IMPLEMENTED

override ENV_m3tior_purge = \
	#NOT IMPLEMENTED

override ENV_m3tior_deb = \
	#NOT IMPLEMENTED

override ENV_m3tior_tarball = \
	#NOT IMPLEMENTED

override ENV_m3tior_archive = \
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
#	BUILD directory while I had mounts to shadowroot / root open... (;-;)
#
override ENV_m3tior_test := \
	#NOT IMPLEMENTED
