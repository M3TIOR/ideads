#!/usr/bin/env python3

#
# M3TIOR 2018
#
# NOTE:
#	so I thought it'd be cool to have an application offer both
#	the curses and qt gui's be able to operate in unison
#
#	maybe I'll put that in a future release :P
#

version = "0.0.1" # major.beta.alpha-hotfix

import os
import sys
import platform
import json
import pathlib
import logging

try:
	# Used for calling system binaries as alternative
	# to internal commands; for performance.
	import sh
except(ImportError):
	sh = False

try:
	# Needed to parse qt stylesheet as input for
	# curses colors; trying to unify the schema.
	import tinycss
except(ImportError):
	tinycss = False

try:
	import curses
except(ImportError):
	curses = False

try:
	import PyQt5 as pyqt
except(ImportError):
	pyqt = False

__all__ = {
	# library standard. TODO: look into how this is used DO WE NEED IT?
}

# if of how we're using exp, we might as well always make sure our data dirs
# actually exists, and can store / has our data.
for name, dir in _dirs.items():
	if not dir.is_dir():
		# also, do that for the parents too, and since this is going to run every
		# time we use pex, regardless of whether by library or application Interface
		# we're also going to mark the exist_ok flag, so that this doesn't raise an
		# error when the directory already exists
		try:
			dir.mkdir(parents=True, exist_ok=True)
		except (pathlib.PermissionError):
			# NOTE:
			#	for future reference, we need to implement a method
			#	of ensuring that our user home isn't write protected.
			#	it may be a sign that said directory isn't what it's supposed
			#	to be. IN PROGRESS
			if name == "user":
				pass # TODO







class GUIError(Exception):
	"""
		An error propogated by any GUI of this application.
	"""

# just so we don't instanciate multiple instances
# of the json encoder and decoder, and this way it looks nice in execution
class _JSON_Parser():
	"""
		Container for the setting json parser instance.
	"""
	# Initially, I thought it would be a good idea to just rebind
	# the encoder and decoder's parser methods as class methods
	# because it'd be easier to have the resources available from the
	# moment this library is accessed. But I decided against it since
	# we'll only ever need the json parser within our settings class
	def __init__(self):
		# configure JSON encoder and decoder for this use case
		self.encoder = json.JSONEncoder()
		self.decoder = json.JSONDecoder()

		# Alias the functions similar to the javascript implemementation
		# That way it's easier for my brain to work with it.
		self.stringify = self.encoder.encode
		self.parse = self.decoder.decode

class GUISettings(dict):
	"""
		Holds the GUI settings for our application. Local class only, controlled
		internally via the gui instanciators.
	"""
	def __init__(self, autosave=-1):
		# Configure initial settings here!
		super().__init__({
			# initial settings

			# This setting limits the RAM usage of the application to
			# When set to -1, the memory limit is unchecked;
			# or in other words, capped by how much you have.
			#
			# This setting is implemented with the intent of removing the
			# ability of users to spoof the application into crashing by
			# overloading RAM through the use of external search functions
			#
			# We don't want usability affected by trolls.
			"MXram":1024*1000*20, # default limit is 20 Megabytes

			# cross platform data directories using pathlib.Path()
			# this will be the first thing added to the standard settings
			"system_dir":(
				pathlib.Path("/") / "ProgramData/pex" if (platform.system() == "Windows")
					# Get our system name so we can decide which system paths to use.
					# If it's Windows, use the windows specific userland.
					else
						# otherwise we use the cross platform, Filesystem Heirarchy Standard
						# NOTE:
						#	the FHS declares the usr/share directory to be a read only
						#	folder, so there won't be any updating or removing
						#	files from there.
						pathlib.Path("/") / "usr/share/pex"
			),
			"user_dir":(
				# set the user dir to a pathlib.Path object that's
				# the combined userland home and what ever is behind the division
				# operator.
				pathlib.Path.home() / "AppData/local/pex" if (platform.system() == "Windows")
					# Get our system name so we can decide which system paths to use.
					# If it's Windows, use the windows specific userland.
					else
						# otherwise we use the cross platform, Filesystem Heirarchy Standard
						pathlib.Path.home() / ".pex"
			)
		})

		self.JSON = _JSON_Parser() # instanciate json parser when needed
		self.update_counter = 0
		self.update_autosave = autosave

		# PERSONAL:
		# I don't really like this syntax all too well because it's
		# a tad confusing when you don't already know that the pathlib.Path
		# rebinds its divison operation to a sort of change dir function.
		self.file = self["user_dir"] / "config.json"
		# the settings are to be saved, per-user. since the basic config is
		# saved internally, there's no need to have a global config unless
		# we plan to implement feature control. But I don't think that's going
		# to be where this project heads since that's really the OS's job.

		# make sure both our default user and system dirs exist
		# before we try and do anything else.
		for dir in [settings["system_dir"], settings["user_dir"]]:
			if not dir:
				# if dir is False or None
				continue # skip it, the user has disabled the directory
			if not dir.is_dir():
				# if the dir doesn'nt exist make sure we try to make it
				try:
					dir.mkdir(parents=True, exist_ok=True)
				except():
					pass # PermissionError TODO

		if not self.file.is_file():
			# if we don't already have a file at the ready, make one with
			# our defaluts so we don't break load the first time we call it.
			# should we decide not to save our data for some reason...
			self.save()
		else:
			# finally, we load our previous settings over our defaults
			# so our settings persist per session
			self.load()


	def save(self):
		try:
			# open in text write mode, initializing the file from scratch
			# text mode is default, but just to be sure, this is explicit.
			with self.file.open("wt") as file:
				# horray for contexts and automatic file io clean-up!
				file.write(self.JSON.stringify(self))

		# shouldn't have any parser errors here since python's dictionary
		# syntax is part of the standard, and will be checked by the python
		# interpreter.
		except():
			pass #File IO Error TODO

	def load(self):
		try:
			json_str = "" # pre allocate for file output buffer

			# open in text mode, so we don't have to worry about weird bytes.
			# we'll let the json parser handle that.
			with self.file.open("rt") as file:
				# wrap the file output buffer, in case our json is too big for
				# a single pass by read.
				#
				# TODO: limit json size so we don't give someone the ability
				#		to overload memory using the damn config...
				while True:
					data = file.read()
					if data == "": 	# when we return end of file or no data
						break		# stop reading from it.
					json_str = json_str + data

			# now we just pass the data into the parser
			# and hope nothing breaks since we've made sure the files
			# output is pre-formated for python's builtin text format.
			json_obj = self.JSON.parse(json_str)

			# then we update the current settings with the ones we just
			# loaded in from our external file.
			self.update(json_obj)

		except():
			pass # File IO Error TODO
		except():
			pass # Parser Error TODO

	# override the builtin dictionary update function so that we can
	# implement our autosave function.
	def update(dict):
		# add to counter for autosave
		self.update_counter = self.update_counter + 1

		# call the inherited dictionary update function
		super().update(dict)

		# only save when the counter rolls over
		if (self.update_autosave >= 0 and
				self.update_counter % self.update_autosave == 0):
			self.save()



def _get_stylesheets(settings, start=-1, end=-1):
	"""
		compiles a list of all the stylesheets from the directories specified
	"""
	stylesheets = []		# stylesheet files, used for hotswap list

	for dir in [settings["system_dir"], settings["user_dir"]]:
		# make sure we're looking through the css subdirectory
		dir = dir / "css"

		# if we don't have the directory, make it
		if not dir.is_dir():
			dir.mkdir(parents=True, exist_ok=True)

		# os.listdir is slightly less expensive, also we have to convert the
		# pathlib.Path to a string before we can pass it to os.listdir
		for file in os.listdir(str(dir)):
			if file[-4,-1] == ".css":
				stylesheets.append(dir / file)
			else:
				pass # shenanigans, there should only be css files there TODO

	return stylesheets # will be pathlib.Path objects




	# do defaults TODO
	curses.init_pair(0, curses.COLOR_VIOLET, curses.COLOR_WHITE) #QMainWindow
	curses.init_pair(1, ) #QWidget


def _select_gui(gui):
	# Handle Explicit Modes
	if mode == "curses" and curses:
		curses.wrapper(curses_gui)
	elif mode == "qt" and pyqt:
		pass
	# Handle Implicit Mode Selection
	#	* default - choose from highest order to lowest
	# _-- FUTURE:
	#	* maybe implement choose by most frequent / favorite
	if pyqt:
		pass
	elif curses:
		curses.wrapper(curses_gui, settings=GUISettings(autosave=5))
	else:
		raise GUIError("No GUI's are available on your system at the moment!")



# XXX SHELL COMMAND MIMICS XXX
#
#	NOTE:
#		all shell command mimics must use the os path library
#		in order to force compliance of the users expected path expression
#		based on the operating system norm. It'd be kinda weird to have
#		one application handle paths differently than the operating system
#		it's running on, and could be a giant frustration to users.

def cd():
	raise NotImplementedError()

def dir():
	raise NotImplementedError()

def mv():
	raise NotImplementedError()

def cp():
	raise NotImplementedError()

def touch():
	raise NotImplementedError()

def mkdir(path, mode=0o777, parents=False, exist_ok=False, builtin_only=True):
	if sh and not builtin_only:
		try:
			sh.mkdir("")
		except(Error):
			pass
	else:
		pathlib.Path(path).mkdir(mode=mode, parents=parents, exist_ok=exist_ok)

def ln():
	raise NotImplementedError()

def rm():
	raise NotImplementedError()





# XXX GUIS XXX

def curses_gui(stdscr, settings=None):
	"""
		To avoid unnecessary extra work and code, this function
		is required to be called by curses.wrapper from the curses
		python library.

		CGI or Command Graphic Interface, is the curses interface for foldit,
		which aims to offer the same UI that the Qt Graphical User Interface
		does within the terminal.
	"""
	# Test Environment
	if not curses:
		raise GUIError("Curses library not available!")
	if not settings:
		settings = GUISettings(autosave=5)
	if tinycss:
		tinyparser = tinycss.make_parser()

	# Import Extensions
	from curses.textpad import Textbox, rectangle

	# Local Root Variables

	# Local Function
	def style(css_path):
		# initialize color pairs with style rules if available
		#
		# color pair index style refference:
		#	0 - QWidget # core, inherited by all objects; the default object style
		#	1
		#	2
		#	3
		#	4
		#	5
		#	6
		#	7
		#
		if tinycss:
			# parse colors from qt stylesheet and reconfigure the built-in colors
			# to be as close to the stylesheet as possible.

			# pre allocate memory for style rules
			rules = None

			if css_path.is_file():
				try:
					with css_path.open("rt") as css:
						# pull rules out of our stylesheet
						tinyparser.parse_stylesheet()
				except():
					pass

				if curses.can_change_color():
					# get colors as close to style as possible TODO
					pass
				else:
					# round off stylesheet colors to builtin presets. TODO
					pass
			else:
				pass 	# Perhaps raise exception, log that we can't load the
						# requested stylesheet, and go back to defaults or last
						# settings TODO
			# TODO IMPLEMENT DEFAULTS

	# XXX -------------------- FUNCTION BODY ------------------------- XXX

	# populate hotswap and select stylesheet
	stylesheets = get_stylesheets(settings)

	try:
		cssconfig = open(csspath, 'r') # open read only
	except(Error):
		# for now, do nothing. Later, check for 404 and perm errors
		# to recommend help for users. TODO
		pass

	# Clear Screen
	stdscr.clear()
	stdscr.bkgd(" ", curses.color_pair(2))
	# Draw Initial Frame

	toolbar = curses.newwin(1, curses.COLS, 0, 0)
	toolbar.bkgd(' ', curses.color_pair(1))
	toolbar.addstr("toolbar!", curses.color_pair(1))

	naviwin = curses.newwin(1, curses.COLS, 1, 0)
	toolbar.bkgdset(curses.COLOR_CYAN)
	naviwin.addstr("abspath!")

	content = curses.newwin(curses.LINES - 3, curses.COLS, 2, 0)
	content.bkgd(" ", curses.color_pair(1))
	content.addstr("put stuff here!")

	# add organized panes to the stdscr so we can do full
	toolbar.overwrite(stdscr)
	naviwin.overwrite(stdscr)
	content.overwrite(stdscr)



	#fldview = curses.newpad()
	#trEview = curses.newpad()
	curses.ungetch(curses.KEY_REFRESH)
	# React To Events
	while True:
		event = stdscr.getch()
		if event == curses.KEY_REFRESH:
			stdscr.refresh()
		elif event == curses.KEY_MOUSE:
			pass
		elif event == ord("e"):
			return


def qt_gui(settings=None):
	pass

if __name__ == "__main__": # CLI
	import argparse

	parser = argparse.ArgumentParser("pex",
		description="""
			A pythonic file explorer for the masses
		"""
	)
	parser.add_argument(""
		help=""
	)

	subparsers = parser.add_subparsers("Command Line Interface")
	command = {
		# environment control
		"cd": subparsers.add_parser("cd",
				help="change working directory"
		),
		"dir": subparsers.add_parser("dir",
				help="list current directory's contents"
		),

		# location control
		"mv": subparsers.add_parser("mv",
				help="move files"
		),
		"cp": subparsers.add_parser("cp",
				help="copy files"
		),

		# data create/delete operations
		"touch": subparsers.add_parser("touch",
				help="make a new file"
		),
		"ln": subparsers.add_parser("ln",
				help="create symbolic and physical links"
		),
		"mkdir": subparsers.add_parser("mkdir",
				help="make a new directory"
		),
		"rm": subparsers.add_parser("rm",
				help="remove file or directory"
		),

		# graphical interfaces
		"gui": subparsers.add_parser("gui",
				help="open graphical interface"
		),
	}

	arguments = parser.parse_args()

	_select_gui(arguments.mode)
