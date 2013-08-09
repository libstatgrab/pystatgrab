#!/usr/bin/env python
#
# i-scream pystatgrab
# http://www.i-scream.org/pystatgrab/
# Copyright (C) 2000-2013 i-scream
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
from subprocess import check_call, check_output, CalledProcessError

import sys
import os

# version of pystatgrab
VERSION = "0.6"

# required version of libstatgrab
LIBSTATGRAB = "0.13"

def warn(*s):
    sys.stderr.write("".join(map(str, s)) + "\n")

def die(*s):
    warn("Error: ", *s)
    sys.exit(1)

def pkg_config(*args):
    """Run pkg-config with the given arguments.
    Return the output as a byte string, or None if it failed."""

    prog = os.environ.get("PKG_CONFIG", "pkg-config")
    try:
        return check_output([prog] + list(args))
    except OSError:
        die("could not run ", prog)
    except CalledProcessError:
        return None

# test for libstatgrab version using pkg-config
if pkg_config("--atleast-version", LIBSTATGRAB, "libstatgrab") is None:
    die("libstatgrab version ", LIBSTATGRAB, " or better is not installed (according to pkg-config)")

# test for _statgrab.c, and try to generate if not found
if not os.path.exists("_statgrab.c"):
    warn("_statgrab.c doesn't exist, trying to use pyrexc to generate it...")
    prog = os.environ.get("PYREXC", "pyrexc")
    try:
        check_call([prog, "_statgrab.pyx"])
    except OSError:
        die("_statgrab.c not present, and could not run ", prog)
    except CalledProcessError:
        die(prog, " failed to generate _statgrab.c")

# get cflags and libs for libstatgrab
cflags = pkg_config("--cflags", "libstatgrab")
libs = pkg_config("--libs", "libstatgrab")

# setup information
setup(name = "pystatgrab",
    version = VERSION,
    description = "Python bindings for libstatgrab",
    author = "i-scream",
    author_email = "support@i-scream.org",
    url = "http://www.i-scream.org/pystatgrab/",
    license = "GNU GPL v2 or later",
    ext_modules=[Extension(
        "_statgrab",
        ["_statgrab.c"],
        extra_compile_args = cflags.split(),
        extra_link_args = libs.split(),
    )],
    py_modules=["statgrab"],
)
