#!/usr/bin/env python3

# NOTE: Monkey patch for souce @ CPython 3.10
#       No guarantee this will work for older or newer versions.
#       There needs to be a better way to implement this.

from zipfile import *
import sys, os

# TODO: DOUBLE CHECK GITHUB AND MAKE SURE I'M NOT WASTING MY TIME.
#       I DID A GLANCE AND THERE ARE A COUPLE SIMILAR PROJECTS.
#
# NOTE: No other project accomplishes what I want to do here. HOWEVER
#   Much can be said about the sad state the ZipFile internals of CPython
#   are in. They suck, the API isn't very friendly to monkey patching,
#   they don't implement compatability for all Zip versions, and they do
#   some really weird shit with async management. I want to rewrite the whole
#   thing from scratch because my Autism OCD brain is screaming at me about it.
#   I feel it's best I just move on for now and temporarily trim the scope of
#   my clang-toolbox.py project (what this is for)

class ZipStream(ZipFile):
	"""By relying on the user to provide accurate data, we don't need access to
	the central directory. This won't support multiple disks, but it can support
	ZIP64 and all compression formats.

	Unlike conventional Python ZipFile, ZipStream only has two modes.
	explicit-create, and read-only; 'x' and 'r' respectively."""

	def __init__(self, file, mode='r', compression=ZIP_STORED, allowZip64=True,
			compresslevel=None, *, strict_timestamps=True, passwd=None):
		""""""
		if mode not in ('r', 'x'):
			raise ValueError("ZipStream requires mode 'r' or 'x'")

		_check_compression(compression)

		self._allowZip64 = allowZip64
		self.debug = 0  # Level of printing: 0 through 3
		self.NameToInfo = {}    # Find file info given name
		self.filelist = []      # List of ZipInfo instances for archive
		self.compression = compression  # Method of compression
		self.compresslevel = compresslevel
		self.mode = mode
		self.pwd = None
		self._comment = b''
		self._strict_timestamps = strict_timestamps
		# set the modified flag so central directory gets written
		# even if no files are added to the archive
		self._didModify = (True if mode == "w" else False)
		# Disregard centeral directory, it's not required for streaming.
		# NOTE: This breaks Zip standard and files that aren't actual zips
		#       could break this routine.
		self.start_dir = 0

		# Check if we were passed a file-like object
		if isinstance(file, os.PathLike):
			file = os.fspath(file)
		if isinstance(file, str):
			# No, it's a filename
			self._filePassed = 0
			self.filename = file
			modeDict = {'r' : 'rb', 'x': 'x+b', 'x+b': 'xb'}
			filemode = modeDict[mode]
			while True:
				try:
					self.fp = io.open(file, filemode)
				except OSError:
					if filemode in modeDict:
						filemode = modeDict[filemode]
						continue
					raise
				break
		else:
			self._filePassed = 1
			self.fp = file
			self.filename = getattr(file, 'name', None)
		self._fileRefCnt = 1
		self._lock = threading.RLock()
		self._seekable = False
		self._writing = False


	def __iter__(self):
		# TODO: when read, populate self.NameToInfo before self.open()
		# NOTE: may need to patch the self.open method to prevent "skipping"
		#       over the already consumed header data.
		pass

	def open(self, name, mode="r", pwd=None, *, force_zip64=False):
		"""Return file-like object for 'name'.
		name is a string for the file name within the ZIP file, or a ZipInfo
		object.
		mode should be 'r' to read a file already in the ZIP file, or 'w' to
		write to a file newly added to the archive.
		pwd is the password to decrypt files (only used for reading).
		When writing, if the file size is not known in advance but may exceed
		2 GiB, pass force_zip64 to use the ZIP64 format, which can handle large
		files.  If the size is known in advance, it is best to pass a ZipInfo
		instance for name, with zinfo.file_size set.
		"""
		if mode != self.mode:
			raise ValueError('mode supplied to open() must match stream mode.')
		if pwd and not isinstance(pwd, bytes):
			raise TypeError("pwd: expected bytes, got %s" % type(pwd).__name__)
		if pwd and (mode == "w"):
			raise ValueError("pwd is only supported for reading files")
		if not self.fp:
			raise ValueError(
				"Attempt to use ZIP archive that was already closed")

	def open(self, name, mode="r", pwd=None, *, force_zip64=False):
		"""Return file-like object for 'name'.
		name is a string for the file name within the ZIP file, or a ZipInfo
		object.
		mode should be 'r' to read a file already in the ZIP file, or 'w' to
		write to a file newly added to the archive.
		pwd is the password to decrypt files (only used for reading).
		When writing, if the file size is not known in advance but may exceed
		2 GiB, pass force_zip64 to use the ZIP64 format, which can handle large
		files.  If the size is known in advance, it is best to pass a ZipInfo
		instance for name, with zinfo.file_size set.
		"""
		if mode != self.mode:
			raise ValueError('mode supplied to open() must match stream mode.')
		if pwd and not isinstance(pwd, bytes):
			raise TypeError("pwd: expected bytes, got %s" % type(pwd).__name__)
		if pwd and (mode == "w"):
			raise ValueError("pwd is only supported for reading files")
		if not self.fp:
			raise ValueError(
				"Attempt to use ZIP archive that was already closed")

		# Make sure we have an info object
		if isinstance(name, ZipInfo):
			# 'name' is already an info object
			zinfo = name
		elif mode == 'w':
			zinfo = ZipInfo(name)
			zinfo.compress_type = self.compression
			zinfo._compresslevel = self.compresslevel
		else:
			# Get info object for name
			zinfo = self.getinfo(name)

		if mode == 'w':
			return self._open_to_write(zinfo, force_zip64=force_zip64)

		if self._writing:
			raise ValueError("Can't read from the ZIP file while there "
					"is an open writing handle on it. "
					"Close the writing handle before trying to read.")

		# Open for reading:
		self._fileRefCnt += 1
		zef_file = _SharedFile(self.fp, zinfo.header_offset,
							   self._fpclose, self._lock, lambda: self._writing)
		try:
			# Skip the file header:
			fheader = zef_file.read(sizeFileHeader)
			if len(fheader) != sizeFileHeader:
				raise BadZipFile("Truncated file header")
			fheader = struct.unpack(structFileHeader, fheader)
			if fheader[_FH_SIGNATURE] != stringFileHeader:
				raise BadZipFile("Bad magic number for file header")

			fname = zef_file.read(fheader[_FH_FILENAME_LENGTH])
			if fheader[_FH_EXTRA_FIELD_LENGTH]:
				zef_file.read(fheader[_FH_EXTRA_FIELD_LENGTH])

			if zinfo.flag_bits & 0x20:
				# Zip 2.7: compressed patched data
				raise NotImplementedError("compressed patched data (flag bit 5)")

			if zinfo.flag_bits & 0x40:
				# strong encryption
				raise NotImplementedError("strong encryption (flag bit 6)")

			if fheader[_FH_GENERAL_PURPOSE_FLAG_BITS] & 0x800:
				# UTF-8 filename
				fname_str = fname.decode("utf-8")
			else:
				fname_str = fname.decode("cp437")

			if fname_str != zinfo.orig_filename:
				raise BadZipFile(
					'File name in directory %r and header %r differ.'
					% (zinfo.orig_filename, fname))

			# check for encrypted flag & handle password
			is_encrypted = zinfo.flag_bits & 0x1
			if is_encrypted:
				if not pwd:
					pwd = self.pwd
				if not pwd:
					raise RuntimeError("File %r is encrypted, password "
									   "required for extraction" % name)
			else:
				pwd = None

			return ZipExtFile(zef_file, mode, zinfo, pwd, True)
		except:
			zef_file.close()
			raise
