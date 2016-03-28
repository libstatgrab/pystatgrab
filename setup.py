#!/usr/bin/env python
#
# i-scream pystatgrab
# http://www.i-scream.org/pystatgrab/
# Copyright (C) 2000-2013 i-scream
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.
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
LIBSTATGRAB = "0.91"

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

# get cflags and libs for libstatgrab
cflags = pkg_config("--cflags", "libstatgrab")
libs = pkg_config("--libs", "libstatgrab")

try:
    import Cython.Distutils
    cmdclass = {"build_ext": Cython.Distutils.build_ext}
    statgrab_src = ["statgrab.pyx"]
except ImportError:
    # Cython is not installed; use the shipped copy of statgrab.c.
    cmdclass = {}
    statgrab_src = ["statgrab.c"]

# setup information
setup(name = "pystatgrab",
    version = VERSION,
    description = "Python bindings for libstatgrab",
    author = "i-scream",
    url = "http://www.i-scream.org/pystatgrab/",
    license = "GNU LGPL v2 or later",
    classifiers = [
        "License :: OSI Approved :: GNU Lesser General Public License v2 or later (LGPLv2+)",
        "Programming Language :: Python :: 2",
        "Programming Language :: Python :: 3",
        "Topic :: System :: Monitoring",
    ],
    cmdclass = cmdclass,
    ext_modules = [Extension(
        "statgrab",
        statgrab_src,
        extra_compile_args = cflags.split(),
        extra_link_args = libs.decode("utf-8").split(),
    )],
)
