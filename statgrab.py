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

import _statgrab

def sg_init():
    return _statgrab.py_sg_init()
def sg_snapshot():
    return _statgrab.py_sg_snapshot()
def sg_shutdown():
    return _statgrab.py_sg_shutdown()
def sg_drop_privileges():
    return _statgrab.py_sg_drop_privileges()
def sg_set_error(code, arg=''):
    return _statgrab.py_sg_set_error(code, arg)
def sg_set_error_with_errno(code, arg=''):
    return _statgrab.py_sg_set_error_with_errno(code, arg)
def sg_get_error():
    return _statgrab.py_sg_get_error()
def sg_get_error_arg():
    return _statgrab.py_sg_get_error_arg()
def sg_get_error_errno():
    return _statgrab.py_sg_get_error_errno()
def sg_str_error(code):
    return _statgrab.py_sg_str_error(code)
def sg_get_host_info():
    return _statgrab.py_sg_get_host_info()
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
def sg_get_fs_stats():
    return _statgrab.py_sg_get_fs_stats()
def sg_get_disk_io_stats():
    return _statgrab.py_sg_get_disk_io_stats()
def sg_get_disk_io_stats_diff():
    return _statgrab.py_sg_get_disk_io_stats_diff()
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
def sg_get_process_stats():
    return _statgrab.py_sg_get_process_stats()
def sg_get_process_count():
    return _statgrab.py_sg_get_process_count()

SG_ERROR_NONE = _statgrab.py_SG_ERROR_NONE
SG_ERROR_ASPRINTF = _statgrab.py_SG_ERROR_ASPRINTF
SG_ERROR_DEVSTAT_GETDEVS = _statgrab.py_SG_ERROR_DEVSTAT_GETDEVS
SG_ERROR_DEVSTAT_SELECTDEVS = _statgrab.py_SG_ERROR_DEVSTAT_SELECTDEVS
SG_ERROR_ENOENT = _statgrab.py_SG_ERROR_ENOENT
SG_ERROR_GETIFADDRS = _statgrab.py_SG_ERROR_GETIFADDRS
SG_ERROR_GETMNTINFO = _statgrab.py_SG_ERROR_GETMNTINFO
SG_ERROR_GETPAGESIZE = _statgrab.py_SG_ERROR_GETPAGESIZE
SG_ERROR_KSTAT_DATA_LOOKUP = _statgrab.py_SG_ERROR_KSTAT_DATA_LOOKUP
SG_ERROR_KSTAT_LOOKUP = _statgrab.py_SG_ERROR_KSTAT_LOOKUP
SG_ERROR_KSTAT_OPEN = _statgrab.py_SG_ERROR_KSTAT_OPEN
SG_ERROR_KSTAT_READ = _statgrab.py_SG_ERROR_KSTAT_READ
SG_ERROR_KVM_GETSWAPINFO = _statgrab.py_SG_ERROR_KVM_GETSWAPINFO
SG_ERROR_KVM_OPENFILES = _statgrab.py_SG_ERROR_KVM_OPENFILES
SG_ERROR_MALLOC = _statgrab.py_SG_ERROR_MALLOC
SG_ERROR_OPEN = _statgrab.py_SG_ERROR_OPEN
SG_ERROR_OPENDIR = _statgrab.py_SG_ERROR_OPENDIR
SG_ERROR_PARSE = _statgrab.py_SG_ERROR_PARSE
SG_ERROR_SETEGID = _statgrab.py_SG_ERROR_SETEGID
SG_ERROR_SETEUID = _statgrab.py_SG_ERROR_SETEUID
SG_ERROR_SETMNTENT = _statgrab.py_SG_ERROR_SETMNTENT
SG_ERROR_SOCKET = _statgrab.py_SG_ERROR_SOCKET
SG_ERROR_SWAPCTL = _statgrab.py_SG_ERROR_SWAPCTL
SG_ERROR_SYSCONF = _statgrab.py_SG_ERROR_SYSCONF
SG_ERROR_SYSCTL = _statgrab.py_SG_ERROR_SYSCTL
SG_ERROR_SYSCTLBYNAME = _statgrab.py_SG_ERROR_SYSCTLBYNAME
SG_ERROR_SYSCTLNAMETOMIB = _statgrab.py_SG_ERROR_SYSCTLNAMETOMIB
SG_ERROR_UNAME = _statgrab.py_SG_ERROR_UNAME
SG_ERROR_UNSUPPORTED = _statgrab.py_SG_ERROR_UNSUPPORTED
SG_ERROR_XSW_VER_MISMATCH = _statgrab.py_SG_ERROR_XSW_VER_MISMATCH

SG_IFACE_DUPLEX_FULL = _statgrab.py_SG_IFACE_DUPLEX_FULL
SG_IFACE_DUPLEX_HALF = _statgrab.py_SG_IFACE_DUPLEX_HALF
SG_IFACE_DUPLEX_UNKNOWN = _statgrab.py_SG_IFACE_DUPLEX_UNKNOWN

SG_PROCESS_STATE_RUNNING = _statgrab.py_SG_PROCESS_STATE_RUNNING
SG_PROCESS_STATE_SLEEPING = _statgrab.py_SG_PROCESS_STATE_SLEEPING
SG_PROCESS_STATE_STOPPED = _statgrab.py_SG_PROCESS_STATE_STOPPED
SG_PROCESS_STATE_ZOMBIE = _statgrab.py_SG_PROCESS_STATE_ZOMBIE
SG_PROCESS_STATE_UNKNOWN = _statgrab.py_SG_PROCESS_STATE_UNKNOWN
