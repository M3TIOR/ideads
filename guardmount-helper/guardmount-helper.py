#!/usr/bin/env python3

# Guardmount Advisory Generator
# Copyright 2018 Ruby Allison Rose (AKA: M3TIOR)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.

from argparse import ArgumentParser
from random import shuffle
from datetime import date

version_no = "0.0.1a"

class TextDatabase():
	"""An extremely simple database optimized for read time performance."""

	def __init__(self, filename, linewidth):
		self.filename = filename
		self.linewidth = linewidth
		try: self.fileobj = open(filename, "r+b")
		except(FileNotFoundError): self.fileobj = open(filename, "w+b")

	def __del__(self):
		self.fileobj.close()

	def add(self, string):
		self.fileobj.seek(0,2)
		self.fileobj.write(string.\
			ljust(self.linewidth).\
			encode("ASCII"))

	def entries(self):
		#cloc = self.fileobj.tell()
		entries = self.fileobj.seek(0,2) // self.linewidth
		#self.fileobj.seek(cloc)
		return entries

	def read(self, lineno):
		self.fileobj.seek(lineno*self.linewidth)
		line = self.fileobj.read(self.linewidth)
		return str(line, encoding="utf-8")

	def remove(self, lines, offset):
		self.fileobj.seek((offset+lines)*self.linewidth)
		total = self.entries()
		for entry in range(offset+lines, total):
			entxt = self.read(entry).encode("ASCII")
			self.fileobj.seek(offset*self.linewidth)
			self.fileobj.write(entxt)
		self.fileobj.truncate((offset+lines)*self.linewidth)


if __name__ == "__main__":
	db = TextDatabase("guardmountnotes.txt", 80)
	parser = ArgumentParser(
		description="A tool to help me give better briefings at Gaurdmount."
	)
	subparsers = parser.add_subparsers()

	def add_wrapper(args):
		db.add(args.STRING)

	def show_wrapper(args):
		if 0 < args.to:
			for entry in range(args.ENTRYNO-1, args.to):
				print(db.read(entry))
		else:
			print(db.read(args.ENTRYNO-1))

	def remove_wrapper(args):
		if args.to:
			db.remove(args.to-args.ENTRYNO-1, args.ENTRYNO-1)
		else:
			db.remove(1, args.ENTRYNO-1)

	add = subparsers.add_parser("add",
		help="Adds a breifing reminder to the database.")
	add.add_argument("STRING", type=str, help="The brief we'll be adding")
	add.set_defaults(func=add_wrapper)

	show = subparsers.add_parser("show",
		help="Displays database entries.")
	show.add_argument("ENTRYNO", type=int, help="The entry number to display.")
	show.add_argument("--to", type=int, metavar="ENDNO", default="-1",
		help="When set, will display all entries from ENTRYNO to ENDNO")
	show.set_defaults(func=show_wrapper)

	remove = subparsers.add_parser("remove",
		help="Removes database entries.")
	remove.add_argument("ENTRYNO", type=int, help="The entry number to remove.")
	remove.add_argument("--to", type=int, metavar="ENDNO",
		help="When set, will remove all entries from ENTRYNO to ENDNO")
	remove.set_defaults(func=remove_wrapper)

	curses = subparsers.add_parser("curses",
		help="Launch the interactive curses mode for this application.")

	args = parser.parse_args()
	if hasattr(args,"func"):
		args.func(args)
		exit()

	# NOTES GENERATION BEGIN!
	print("".join("-" for i in range(80)))
	print("Guardmount Advisory Generator: %s" % (version_no))
	print("Author: M3TIOR\n\n")

	if date.today().weekday() > 4:
		print("Reminder: TIME SHEETS ARE DUE!\n")

	total = db.entries()
	scrambler = [e for e in range(total)]
	shuffle(scrambler)
	for each in scrambler[0:5]:
		print(db.read(each)+"\n")
