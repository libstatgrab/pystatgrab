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

ctypedef long time_t

cdef extern from "statgrab.h":
    ctypedef struct sg_cpu_stats:
        long long user
        long long kernel
        long long idle
        long long iowait
        long long swap
        long long nice
        long long total
        time_t systime

    ctypedef struct sg_cpu_percents:
        float user
        float kernel
        float idle
        float iowait
        float swap
        float nice
        time_t time_taken

    ctypedef struct sg_mem_stats:
        long long total
        long long free
        long long used
        long long cache

    ctypedef struct sg_load_stats:
        double min1
        double min5
        double min15

    ctypedef struct sg_user_stats:
        char *name_list
        int num_entries

    ctypedef struct sg_swap_stats:
        long long total
        long long used
        long long free

    ctypedef struct sg_host_info:
        char *os_name
        char *os_release
        char *os_version
        char *platform
        char *hostname
        time_t uptime

    ctypedef struct sg_fs_stats:
        char *device_name
        char *fs_type
        char *mnt_point
        long long size
        long long used
        long long avail
        long long total_inodes
        long long used_inodes
        long long free_inodes

    ctypedef struct sg_disk_io_stats:
        char *disk_name
        long long read_bytes
        long long write_bytes
        time_t systime

    ctypedef struct sg_process_count:
        int total
        int running
        int sleeping
        int stopped
        int zombie

    ctypedef struct sg_network_io_stats:
        char *interface_name
        long long tx
        long long rx
        long long ipackets
        long long opackets
        long long ierrors
        long long oerrors
        long long collisions
        time_t systime

    ctypedef enum sg_iface_duplex:
        SG_IFACE_DUPLEX_FULL
        SG_IFACE_DUPLEX_HALF
        SG_IFACE_DUPLEX_UNKNOWN

    ctypedef struct sg_network_iface_stats:
        char *interface_name
        int speed
        sg_iface_duplex dup
        int up

    ctypedef struct sg_page_stats:
        long long pages_pagein
        long long pages_pageout
        time_t systime

    cdef extern sg_cpu_stats *sg_get_cpu_stats()
    cdef extern sg_cpu_stats *sg_get_cpu_stats_diff()
    cdef extern sg_cpu_percents *sg_get_cpu_percents()
    cdef extern sg_mem_stats *sg_get_mem_stats()
    cdef extern sg_load_stats *sg_get_load_stats()
    cdef extern sg_user_stats *sg_get_user_stats()
    cdef extern sg_swap_stats *sg_get_swap_stats()
    cdef extern sg_host_info *sg_get_host_info()
    cdef extern sg_fs_stats *sg_get_fs_stats(int *entries)
    cdef extern sg_disk_io_stats *sg_get_disk_io_stats(int *entries)
    cdef extern sg_disk_io_stats *sg_get_disk_io_stats_diff(int *entries)
    cdef extern sg_process_count *sg_get_process_count()
    cdef extern sg_network_io_stats *sg_get_network_io_stats(int *entries)
    cdef extern sg_network_io_stats *sg_get_network_io_stats_diff(int *entries)
    cdef extern sg_network_iface_stats *sg_get_network_iface_stats(int *entries)
    cdef extern sg_page_stats *sg_get_page_stats()
    cdef extern sg_page_stats *sg_get_page_stats_diff()
    cdef extern int sg_init()
    cdef extern int sg_drop_privileges()


py_SG_IFACE_DUPLEX_FULL = SG_IFACE_DUPLEX_FULL
py_SG_IFACE_DUPLEX_HALF = SG_IFACE_DUPLEX_HALF
py_SG_IFACE_DUPLEX_UNKNOWN = SG_IFACE_DUPLEX_UNKNOWN


class Result:
    def __init__(self, attrs):
        self.attrs = attrs
        for attr in attrs:
            setattr(self, attr, attrs[attr])
    def __getitem__(self, item):
        return getattr(self, item)
    def __repr__(self):
        return str(self.attrs)

class StatgrabException(Exception):
    def __init__(self, value):
        self.value = value
    def __str__(self):
        return repr(self.value)


def py_sg_get_cpu_stats():
    cdef sg_cpu_stats *s
    s = sg_get_cpu_stats()
    if s == NULL:
        raise StatgrabException, 'sg_get_cpu_stats() returned NULL'
    return Result(
        {'user': s.user,
         'kernel': s.kernel,
         'idle': s.idle,
         'iowait': s.iowait,
         'swap': s.swap,
         'nice': s.nice,
         'total': s.total,
         'systime': s.systime,
        }
    )

def py_sg_get_cpu_stats_diff():
    cdef sg_cpu_stats *s
    s = sg_get_cpu_stats_diff()
    if s == NULL:
        raise StatgrabException, 'sg_get_cpu_stats_diff() returned NULL'
    return Result(
        {'user': s.user,
         'kernel': s.kernel,
         'idle': s.idle,
         'iowait': s.iowait,
         'swap': s.swap,
         'nice': s.nice,
         'total': s.total,
         'systime': s.systime,
        }
    )

def py_sg_get_cpu_percents():
    cdef sg_cpu_percents *s
    s = sg_get_cpu_percents()
    if s == NULL:
        raise StatgrabException, 'sg_get_cpu_percents() returned NULL'
    return Result(
        {'user': s.user,
         'kernel': s.kernel,
         'idle': s.idle,
         'iowait': s.iowait,
         'swap': s.swap,
         'nice': s.nice,
         'time_taken': s.time_taken,
        }
    )

def py_sg_get_mem_stats():
    cdef sg_mem_stats *s
    s = sg_get_mem_stats()
    if s == NULL:
        raise StatgrabException, 'sg_get_mem_stats() returned NULL'
    return Result(
        {'total': s.total,
         'used': s.used,
         'free': s.free,
         'cache': s.cache,
        }
    )

def py_sg_get_load_stats():
    cdef sg_load_stats *s
    s = sg_get_load_stats()
    if s == NULL:
        raise StatgrabException, 'sg_get_load_stats() returned NULL'
    return Result(
        {'min1': s.min1,
         'min5': s.min5,
         'min15': s.min15,
        }
    )

def py_sg_get_user_stats():
    cdef sg_user_stats *s
    s = sg_get_user_stats()
    if s == NULL:
        raise StatgrabException, 'sg_get_user_stats() returned NULL'
    return Result(
        {'name_list': s.name_list,
         'num_entries': s.num_entries,
        }
    )

def py_sg_get_swap_stats():
    cdef sg_swap_stats *s
    s = sg_get_swap_stats()
    if s == NULL:
        raise StatgrabException, 'sg_get_swap_stats() returned NULL'
    return Result(
        {'total': s.total,
         'used': s.used,
         'free': s.free,
        }
    )

def py_sg_get_host_info():
    cdef sg_host_info *s
    s = sg_get_host_info()
    if s == NULL:
        raise StatgrabException, 'sg_get_host_info() returned NULL'
    return Result(
        {'os_name': s.os_name,
         'os_release': s.os_release,
         'os_version': s.os_version,
         'platform': s.platform,
         'hostname': s.hostname,
         'uptime': s.uptime,
        }
    )

def py_sg_get_fs_stats():
    cdef sg_fs_stats *s
    cdef int entries
    s = sg_get_fs_stats(&entries)
    if s == NULL:
        raise StatgrabException, 'sg_get_fs_stats() returned NULL'
    list = []
    for i from 0 <= i < entries:
        list.append(Result(
            {'device_name': s.device_name,
             'fs_type': s.fs_type,
             'mnt_point': s.mnt_point,
             'size': s.size,
             'used': s.used,
             'avail': s.avail,
             'total_inodes': s.total_inodes,
             'used_inodes': s.used_inodes,
             'free_inodes': s.free_inodes,
            }
        ))
        s = s + 1
    return list

def py_sg_get_disk_io_stats():
    cdef sg_disk_io_stats *s
    cdef int entries
    s = sg_get_disk_io_stats(&entries)
    if s == NULL:
        raise StatgrabException, 'sg_get_disk_io_stats() returned NULL'
    list = []
    for i from 0 <= i < entries:
        list.append(Result(
            {'disk_name': s.disk_name,
             'read_bytes': s.read_bytes,
             'write_bytes': s.write_bytes,
             'systime': s.systime,
            }
        ))
        s = s + 1
    return list

def py_sg_get_disk_io_stats_diff():
    cdef sg_disk_io_stats *s
    cdef int entries
    s = sg_get_disk_io_stats_diff(&entries)
    if s == NULL:
        raise StatgrabException, 'sg_get_disk_io_stats_diff() returned NULL'
    list = []
    for i from 0 <= i < entries:
        list.append(Result(
            {'disk_name': s.disk_name,
             'read_bytes': s.read_bytes,
             'write_bytes': s.write_bytes,
             'systime': s.systime,
            }
        ))
        s = s + 1
    return list

def py_sg_get_process_count():
    cdef sg_process_count *s
    s = sg_get_process_count()
    if s == NULL:
        raise StatgrabException, 'sg_get_process_count() returned NULL'
    return Result(
        {'total': s.total,
         'running': s.running,
         'sleeping': s.sleeping,
         'stopped': s.stopped,
         'zombie': s.zombie,
        }
    )

def py_sg_get_network_io_stats():
    cdef sg_network_io_stats *s
    cdef int entries
    s = sg_get_network_io_stats(&entries)
    if s == NULL:
        raise StatgrabException, 'sg_get_network_io_stats() returned NULL'
    list = []
    for i from 0 <= i < entries:
        list.append(Result(
            {'interface_name': s.interface_name,
             'tx': s.tx,
             'rx': s.rx,
             'ipackets': s.ipackets,
             'opackets': s.opackets,
             'ierrors': s.ierrors,
             'oerrors': s.oerrors,
             'collisions': s.collisions,
             'systime': s.systime,
            }
        ))
        s = s + 1
    return list

def py_sg_get_network_io_stats_diff():
    cdef sg_network_io_stats *s
    cdef int entries
    s = sg_get_network_io_stats_diff(&entries)
    if s == NULL:
        raise StatgrabException, 'sg_get_network_io_stats_diff() returned NULL'
    list = []
    for i from 0 <= i < entries:
        list.append(Result(
            {'interface_name': s.interface_name,
             'tx': s.tx,
             'rx': s.rx,
             'ipackets': s.ipackets,
             'opackets': s.opackets,
             'ierrors': s.ierrors,
             'oerrors': s.oerrors,
             'collisions': s.collisions,
             'systime': s.systime,
            }
        ))
        s = s + 1
    return list

def py_sg_get_network_iface_stats():
    cdef sg_network_iface_stats *s
    cdef int entries
    s = sg_get_network_iface_stats(&entries)
    if s == NULL:
        raise StatgrabException, 'sg_get_network_iface_stats() returned NULL'
    list = []
    for i from 0 <= i < entries:
        list.append(Result(
            {'interface_name': s.interface_name,
             'speed': s.speed,
             'dup': s.dup,
             'up' : s.up,
            }
        ))
        s = s + 1
    return list

def py_sg_get_page_stats():
    cdef sg_page_stats *s
    s = sg_get_page_stats()
    if s == NULL:
        raise StatgrabException, 'sg_get_page_stats() returned NULL'
    return Result(
        {'pages_pagein': s.pages_pagein,
         'pages_pageout': s.pages_pageout,
        }
    )

def py_sg_get_page_stats_diff():
    cdef sg_page_stats *s
    s = sg_get_page_stats_diff()
    if s == NULL:
        raise StatgrabException, 'sg_get_page_stats_diff() returned NULL'
    return Result(
        {'pages_pagein': s.pages_pagein,
         'pages_pageout': s.pages_pageout,
        }
    )

def py_sg_init():
    if sg_init() == 0:
        return True
    else:
        return False

def py_sg_drop_privileges():
    if sg_drop_privileges() == 0:
        return True
    else:
        return False
