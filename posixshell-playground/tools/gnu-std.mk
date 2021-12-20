#!/usr/bin/make

# M3TIOR 2017
#	This file defines some variables commonly used in GNU makefiles.
#	To be more specific though, they're the variables that have been made standard
#	within the language by GNU, but are not required. This file actually just helps
#	me remember that I should use them.
#

# for help: https://www.gnu.org/software/make/manual/html_node/Directory-Variables.html#Directory-Variables
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
srcdir			?= $(PATH_ABSOLUTE)
