#!/usr/bin/env python
#
# setup.py - distfiles configuration for pystatgrab
#
# $Id$
#
"""Python bindings for libstatgrab."""

from distutils.core import setup, Extension
from commands import getstatusoutput

import sys
import os

# version of pystatgrab
VERSION = "0.1"

# required version of libstatgrab
LIBSTATGRAB = "0.9"

# test for pkg-config presence
if os.system("pkg-config --version >/dev/null 2>&1"):
	sys.exit("Error, could not find pkg-config.")

# test for libstatgrab presence using pkg-config
if os.system("pkg-config --exists libstatgrab"):
	sys.exit("Error, libstatgrab is not installed (according to pkg-config).")

# test for libstatgrab version using pkg-config
if os.system("pkg-config --atleast-version=%s libstatgrab" % LIBSTATGRAB):
	sys.exit("Error, need at least libstatgrab version %s." % LIBSTATGRAB)

# test for statgrab.c, and try to generate if not found
if not os.path.exists("statgrab.c"):
	print "statgrab.c doesn't exist, trying to use pyrexc to generate it..."
	if os.system("pyrexc --version >/dev/null 2>&1"):
		sys.exit("Error, statgrab.c not present, and can't find pyrexc to generate it with.")
	else:
		if os.system("pyrexc statgrab.pyx"):
			sys.exit("Error, pyrexc failed to generate statgrab.c")

# get cflags and libs for libstatgrab
cflags = getstatusoutput("pkg-config --cflags libstatgrab")
libs = getstatusoutput("pkg-config --libs libstatgrab")

if cflags[0] != 0:
	sys.exit("Failed to get cflags: " + cflags[1])

if libs[0] != 0:
	exit("Failed to get libs: " + libs[1])

# setup information
setup(	name = "pystatgrab",
	version = VERSION,
	description = "Python bindings for libstatgrab",
	author = "i-scream",
	author_email = "dev@i-scream.org",
	url = "http://www.i-scream.org/libstatgrab/",
	license = "GNU GPL v2 or later",
	ext_modules=[Extension(
		"statgrab",
		["statgrab.c"],
		extra_compile_args = cflags[1].split(),
		extra_link_args = libs[1].split(),
	)],
)
