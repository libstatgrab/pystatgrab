#!/usr/bin/env python
#
# i-scream pystatgrab
# http://www.i-scream.org/pystatgrab/
# Copyright (C) 2000-2004 i-scream
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
# $Id$
#
"""Python bindings for libstatgrab."""

from distutils.core import setup, Extension
from commands import getstatusoutput

import sys
import os

# version of pystatgrab
VERSION = "0.5"

# required version of libstatgrab
LIBSTATGRAB = "0.13"

# test for pkg-config presence
if os.system("pkg-config --version >/dev/null 2>&1"):
	sys.exit("Error, could not find pkg-config.")

# test for libstatgrab presence using pkg-config
if os.system("pkg-config --exists libstatgrab"):
	sys.exit("Error, libstatgrab is not installed (according to pkg-config).")

# test for libstatgrab version using pkg-config
if os.system("pkg-config --atleast-version=%s libstatgrab" % LIBSTATGRAB):
	sys.exit("Error, need at least libstatgrab version %s." % LIBSTATGRAB)

# test for _statgrab.c, and try to generate if not found
if not os.path.exists("_statgrab.c"):
	print "_statgrab.c doesn't exist, trying to use pyrexc to generate it..."
	if os.system("pyrexc --version >/dev/null 2>&1"):
		sys.exit("Error, _statgrab.c not present, and can't find pyrexc to generate it with.")
	else:
		if os.system("pyrexc _statgrab.pyx"):
			sys.exit("Error, pyrexc failed to generate _statgrab.c")

# get cflags and libs for libstatgrab
cflags = getstatusoutput("pkg-config --cflags libstatgrab")
libs = getstatusoutput("pkg-config --libs libstatgrab")

if cflags[0] != 0:
	sys.exit("Failed to get cflags: " + cflags[1])

if libs[0] != 0:
	sys.exit("Failed to get libs: " + libs[1])

# setup information
setup(	name = "pystatgrab",
	version = VERSION,
	description = "Python bindings for libstatgrab",
	author = "i-scream",
	author_email = "support@i-scream.org",
	url = "http://www.i-scream.org/pystatgrab/",
	license = "GNU GPL v2 or later",
	ext_modules=[Extension(
		"_statgrab",
		["_statgrab.c"],
		extra_compile_args = cflags[1].split(),
		extra_link_args = libs[1].split(),
	)],
	py_modules=["statgrab"],
)
