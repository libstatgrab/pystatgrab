#
# i-scream pystatgrab
# http://www.i-scream.org
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

import _statgrab

def get_cpu_totals():
    return _statgrab.py_get_cpu_totals()
def get_cpu_diff():
    return _statgrab.py_get_cpu_diff()
def cpu_percent_usage():
    return _statgrab.py_cpu_percent_usage()
def get_memory_stats():
    return _statgrab.py_get_memory_stats()
def get_load_stats():
    return _statgrab.py_get_load_stats()
def get_user_stats():
    return _statgrab.py_get_user_stats()
def get_swap_stats():
    return _statgrab.py_get_swap_stats()
def get_general_stats():
    return _statgrab.py_get_general_stats()
def get_disk_stats():
    return _statgrab.py_get_disk_stats()
def get_diskio_stats():
    return _statgrab.py_get_diskio_stats()
def get_diskio_stats_diff():
    return _statgrab.py_get_diskio_stats_diff()
def get_process_stats():
    return _statgrab.py_get_process_stats()
def get_network_stats():
    return _statgrab.py_get_network_stats()
def get_network_stats_diff():
    return _statgrab.py_get_network_stats_diff()
def get_network_iface_stats():
    return _statgrab.py_get_network_iface_stats()
def get_page_stats():
    return _statgrab.py_get_page_stats()
def get_page_stats_diff():
    return _statgrab.py_get_page_stats_diff()
def statgrab_init():
    return _statgrab.py_statgrab_init()
def statgrab_drop_privileges():
    return _statgrab.py_statgrab_drop_privileges()

FULL_DUPLEX = _statgrab.py_FULL_DUPLEX
HALF_DUPLEX = _statgrab.py_HALF_DUPLEX
UNKNOWN_DUPLEX = _statgrab.py_UNKNOWN_DUPLEX
