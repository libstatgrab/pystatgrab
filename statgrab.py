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

def sg_get_cpu_stats():
    return _statgrab.py_sg_get_cpu_stats()
def sg_get_cpu_stats_diff():
    return _statgrab.py_sg_get_cpu_stats_diff()
def sg_get_cpu_percents():
    return _statgrab.py_sg_get_cpu_percents()
def sg_get_mem_stats():
    return _statgrab.py_sg_get_mem_stats()
def sg_get_load_stats():
    return _statgrab.py_sg_get_load_stats()
def sg_get_user_stats():
    return _statgrab.py_sg_get_user_stats()
def sg_get_swap_stats():
    return _statgrab.py_sg_get_swap_stats()
def sg_get_host_info():
    return _statgrab.py_sg_get_host_info()
def sg_get_fs_stats():
    return _statgrab.py_sg_get_fs_stats()
def sg_get_disk_io_stats():
    return _statgrab.py_sg_get_disk_io_stats()
def sg_get_disk_io_stats_diff():
    return _statgrab.py_sg_get_disk_io_stats_diff()
def sg_get_process_count():
    return _statgrab.py_sg_get_process_count()
def sg_get_network_io_stats():
    return _statgrab.py_sg_get_network_io_stats()
def sg_get_network_io_stats_diff():
    return _statgrab.py_sg_get_network_io_stats_diff()
def sg_get_network_iface_stats():
    return _statgrab.py_sg_get_network_iface_stats()
def sg_get_page_stats():
    return _statgrab.py_sg_get_page_stats()
def sg_get_page_stats_diff():
    return _statgrab.py_sg_get_page_stats_diff()
def sg_init():
    return _statgrab.py_sg_init()
def sg_drop_privileges():
    return _statgrab.py_sg_drop_privileges()

SG_IFACE_DUPLEX_FULL = _statgrab.py_SG_IFACE_DUPLEX_FULL
SG_IFACE_DUPLEX_HALF = _statgrab.py_SG_IFACE_DUPLEX_HALF
SG_IFACE_DUPLEX_UNKNOWN = _statgrab.py_SG_IFACE_DUPLEX_UNKNOWN
