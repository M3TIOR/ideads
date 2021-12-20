#!/usr/bin/make

# for help: https://www.gnu.org/software/make/manual/html_node/Directory-Variables.html#Directory-Variables
#
# Script global paths
#
#
prefix 			?= /usr/local
exec_prefix 	?= $(prefix)
bindir 			?= $(exec_prefix)/bin
sbindir			?= $(exec_prefix)/sbin
libexecdir		?= $(exec_prefix)/libexec
datarootdir		?= $(prefix)/share
datadir			?= $(datarootdir)
sysconfdir		?= $(prefix)/etc
sharedstatedir	?= $(prefix)/com
localstatedir	?= $(prefix)/var
runstatedir		?= $(localstatedir)/run
includedir		?= $(prefix)/include
oldincludedir	?= /usr/include
docdir			?= $(datarootdir)/doc/$(1)
infodir			?= $(datarootdir)/info
htmldir			?= $(docdir)
dvidir			?= $(docdir)
pdfdir			?= $(docdir)
psdir			?= $(docdir)
libdir 			?= $(exec_prefix)/lib
lispdir			?= $(datarootdir)/emacs/site-lisp
localedir 		?= $(datarootdir)/locale
mandir			?= $(datarootdir)/man
# srcdir			?= /

all: ;
	# Resolve all targets

install: ;
	# Build and install everything

install-html: ;
	# installs html documentation
install-dvi: ;
	# installs dvi documentation
install-pdf: ;
	# installs pdf documentation
install-ps: ;
	# installs ps documentation

uninstall: ;
	# deletes all installed files

install-strip: ;
	#https://www.gnu.org/software/make/manual/html_node/Standard-Targets.html#Standard-Targets

clean: ;
	# Delete all files in the current directory that are normally created by building the program.

distclean: ;
	# Delete all files in the current directory (or created by this makefile) that are created by configuring or building the program.

mostlyclean: ;
	# Like ‘clean’, but may refrain from deleting a few files that people normally don’t want to recompile.

maintainer-clean: ;
	# Delete almost everything that can be reconstructed with this Makefile. This typically includes everything deleted by distclean, plus more: C source files produced by Bison, tags tables, Info files, and so on.

TAGS: ;
	# Update a tags table for this program.

info: ;
	# Generate any Info files needed. The best way to write the rules is as follows:

dvi: ;
	# generate dvi documentation
html: ;
	# generate html documentation
pdf: ;
	# generate pdf documentation
ps: ;
	# generate ps documentation

dist: ;
	# Create a distribution tar file for this program. The tar file should be set up so that the file names in the tar file start with a subdirectory name which is the name of the package it is a distribution for. This name can include the version number.

check: ;
	# Perform self-tests (if any). The user must build the program before running the tests, but need not install the program; you should write the self-tests so that they work when the program is built but not installed.

installcheck: ;
	# Perform installation tests (if any). The user must build and install the program before running the tests. You should not assume that $(bindir) is in the search path.

installdirs: ;
	# It’s useful to add a target named ‘installdirs’ to create the directories where files are installed, and their parent directories. There is a script called mkinstalldirs which is convenient for this;
