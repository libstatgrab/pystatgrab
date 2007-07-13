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

ctypedef long time_t
ctypedef int pid_t
ctypedef int uid_t
ctypedef int gid_t

cdef extern from "statgrab.h":
    cdef extern int sg_init()
    cdef extern int sg_shutdown()
    cdef extern int sg_snapshot()
    cdef extern int sg_drop_privileges()

    ctypedef enum sg_error:
        SG_ERROR_NONE = 0
        SG_ERROR_ASPRINTF
        SG_ERROR_DEVSTAT_GETDEVS
        SG_ERROR_DEVSTAT_SELECTDEVS
        SG_ERROR_ENOENT
        SG_ERROR_GETIFADDRS
        SG_ERROR_GETMNTINFO
        SG_ERROR_GETPAGESIZE
        SG_ERROR_KSTAT_DATA_LOOKUP
        SG_ERROR_KSTAT_LOOKUP
        SG_ERROR_KSTAT_OPEN
        SG_ERROR_KSTAT_READ
        SG_ERROR_KVM_GETSWAPINFO
        SG_ERROR_KVM_OPENFILES
        SG_ERROR_MALLOC
        SG_ERROR_OPEN
        SG_ERROR_OPENDIR
        SG_ERROR_PARSE
        SG_ERROR_SETEGID
        SG_ERROR_SETEUID
        SG_ERROR_SETMNTENT
        SG_ERROR_SOCKET
        SG_ERROR_SWAPCTL
        SG_ERROR_SYSCONF
        SG_ERROR_SYSCTL
        SG_ERROR_SYSCTLBYNAME
        SG_ERROR_SYSCTLNAMETOMIB
        SG_ERROR_UNAME
        SG_ERROR_UNSUPPORTED
        SG_ERROR_XSW_VER_MISMATCH

    cdef extern void sg_set_error(sg_error code, char *arg)
    cdef extern void sg_set_error_with_errno(sg_error code, char *arg)
    cdef extern sg_error sg_get_error()
    cdef extern char *sg_get_error_arg()
    cdef extern int sg_get_error_errno()
    cdef extern char *sg_str_error(sg_error code)

    ctypedef struct sg_host_info:
        char *os_name
        char *os_release
        char *os_version
        char *platform
        char *hostname
        time_t uptime

    cdef extern sg_host_info *sg_get_host_info()

    ctypedef struct sg_cpu_stats:
        long long user
        long long kernel
        long long idle
        long long iowait
        long long swap
        long long nice
        long long total
        time_t systime

    cdef extern sg_cpu_stats *sg_get_cpu_stats()
    cdef extern sg_cpu_stats *sg_get_cpu_stats_diff()

    ctypedef struct sg_cpu_percents:
        float user
        float kernel
        float idle
        float iowait
        float swap
        float nice
        time_t time_taken

    cdef extern sg_cpu_percents *sg_get_cpu_percents()

    ctypedef struct sg_mem_stats:
        long long total
        long long free
        long long used
        long long cache

    cdef extern sg_mem_stats *sg_get_mem_stats()

    ctypedef struct sg_load_stats:
        double min1
        double min5
        double min15

    cdef extern sg_load_stats *sg_get_load_stats()

    ctypedef struct sg_user_stats:
        char *name_list
        int num_entries

    cdef extern sg_user_stats *sg_get_user_stats()

    ctypedef struct sg_swap_stats:
        long long total
        long long used
        long long free

    cdef extern sg_swap_stats *sg_get_swap_stats()

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
        long long avail_inodes
        long long io_size
        long long block_size
        long long total_blocks
        long long free_blocks
        long long used_blocks
        long long avail_blocks

    cdef extern sg_fs_stats *sg_get_fs_stats(int *entries)

    ctypedef struct sg_disk_io_stats:
        char *disk_name
        long long read_bytes
        long long write_bytes
        time_t systime

    cdef extern sg_disk_io_stats *sg_get_disk_io_stats(int *entries)
    cdef extern sg_disk_io_stats *sg_get_disk_io_stats_diff(int *entries)

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

    cdef extern sg_network_io_stats *sg_get_network_io_stats(int *entries)
    cdef extern sg_network_io_stats *sg_get_network_io_stats_diff(int *entries)

    ctypedef enum sg_iface_duplex:
        SG_IFACE_DUPLEX_FULL
        SG_IFACE_DUPLEX_HALF
        SG_IFACE_DUPLEX_UNKNOWN

    ctypedef struct sg_network_iface_stats:
        char *interface_name
        int speed
        sg_iface_duplex duplex
        int up

    cdef extern sg_network_iface_stats *sg_get_network_iface_stats(int *entries)

    ctypedef struct sg_page_stats:
        long long pages_pagein
        long long pages_pageout
        time_t systime

    cdef extern sg_page_stats *sg_get_page_stats()
    cdef extern sg_page_stats *sg_get_page_stats_diff()

    ctypedef enum sg_process_state:
        SG_PROCESS_STATE_RUNNING
        SG_PROCESS_STATE_SLEEPING
        SG_PROCESS_STATE_STOPPED
        SG_PROCESS_STATE_ZOMBIE
        SG_PROCESS_STATE_UNKNOWN

    ctypedef struct sg_process_stats:
        char *process_name
        char *proctitle
        pid_t pid
        pid_t parent
        pid_t pgid
        uid_t uid
        uid_t euid
        gid_t gid
        gid_t egid
        unsigned long long proc_size
        unsigned long long proc_resident
        time_t time_spent
        double cpu_percent
        int nice
        sg_process_state state

    cdef extern sg_process_stats *sg_get_process_stats(int *entries)

    ctypedef struct sg_process_count:
        int total
        int running
        int sleeping
        int stopped
        int zombie

    cdef extern sg_process_count *sg_get_process_count()


py_SG_ERROR_NONE = SG_ERROR_NONE
py_SG_ERROR_ASPRINTF = SG_ERROR_ASPRINTF
py_SG_ERROR_DEVSTAT_GETDEVS = SG_ERROR_DEVSTAT_GETDEVS
py_SG_ERROR_DEVSTAT_SELECTDEVS = SG_ERROR_DEVSTAT_SELECTDEVS
py_SG_ERROR_ENOENT = SG_ERROR_ENOENT
py_SG_ERROR_GETIFADDRS = SG_ERROR_GETIFADDRS
py_SG_ERROR_GETMNTINFO = SG_ERROR_GETMNTINFO
py_SG_ERROR_GETPAGESIZE = SG_ERROR_GETPAGESIZE
py_SG_ERROR_KSTAT_DATA_LOOKUP = SG_ERROR_KSTAT_DATA_LOOKUP
py_SG_ERROR_KSTAT_LOOKUP = SG_ERROR_KSTAT_LOOKUP
py_SG_ERROR_KSTAT_OPEN = SG_ERROR_KSTAT_OPEN
py_SG_ERROR_KSTAT_READ = SG_ERROR_KSTAT_READ
py_SG_ERROR_KVM_GETSWAPINFO = SG_ERROR_KVM_GETSWAPINFO
py_SG_ERROR_KVM_OPENFILES = SG_ERROR_KVM_OPENFILES
py_SG_ERROR_MALLOC = SG_ERROR_MALLOC
py_SG_ERROR_OPEN = SG_ERROR_OPEN
py_SG_ERROR_OPENDIR = SG_ERROR_OPENDIR
py_SG_ERROR_PARSE = SG_ERROR_PARSE
py_SG_ERROR_SETEGID = SG_ERROR_SETEGID
py_SG_ERROR_SETEUID = SG_ERROR_SETEUID
py_SG_ERROR_SETMNTENT = SG_ERROR_SETMNTENT
py_SG_ERROR_SOCKET = SG_ERROR_SOCKET
py_SG_ERROR_SWAPCTL = SG_ERROR_SWAPCTL
py_SG_ERROR_SYSCONF = SG_ERROR_SYSCONF
py_SG_ERROR_SYSCTL = SG_ERROR_SYSCTL
py_SG_ERROR_SYSCTLBYNAME = SG_ERROR_SYSCTLBYNAME
py_SG_ERROR_SYSCTLNAMETOMIB = SG_ERROR_SYSCTLNAMETOMIB
py_SG_ERROR_UNAME = SG_ERROR_UNAME
py_SG_ERROR_UNSUPPORTED = SG_ERROR_UNSUPPORTED
py_SG_ERROR_XSW_VER_MISMATCH = SG_ERROR_XSW_VER_MISMATCH

py_SG_IFACE_DUPLEX_FULL = SG_IFACE_DUPLEX_FULL
py_SG_IFACE_DUPLEX_HALF = SG_IFACE_DUPLEX_HALF
py_SG_IFACE_DUPLEX_UNKNOWN = SG_IFACE_DUPLEX_UNKNOWN

py_SG_PROCESS_STATE_RUNNING = SG_PROCESS_STATE_RUNNING
py_SG_PROCESS_STATE_SLEEPING = SG_PROCESS_STATE_SLEEPING
py_SG_PROCESS_STATE_STOPPED = SG_PROCESS_STATE_STOPPED
py_SG_PROCESS_STATE_ZOMBIE = SG_PROCESS_STATE_ZOMBIE
py_SG_PROCESS_STATE_UNKNOWN = SG_PROCESS_STATE_UNKNOWN


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


def py_sg_init():
    if sg_init() == 0:
        return True
    else:
        return False

def py_sg_shutdown():
    if sg_shutdown() == 0:
        return True
    else:
        return False

def py_sg_snapshot():
    if sg_snapshot() == 0:
        return True
    else:
        return False

def py_sg_drop_privileges():
    if sg_drop_privileges() == 0:
        return True
    else:
        return False

def py_sg_set_error(code, arg):
    sg_set_error(code, arg)

def py_sg_set_error_with_errno(code, arg):
    sg_set_error_with_errno(code, arg)

def py_sg_get_error():
    cdef sg_error s
    s = sg_get_error()
    return s

def py_sg_get_error_arg():
    s = sg_get_error_arg()
    return s

def py_sg_get_error_errno():
    s = sg_get_error_errno()
    return s

def py_sg_str_error(code):
    s = sg_str_error(code)
    return s

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
             'avail_inodes': s.avail_inodes,
             'io_size': s.io_size,
             'block_size': s.block_size,
             'total_blocks': s.total_blocks,
             'free_blocks': s.free_blocks,
             'used_blocks': s.used_blocks,
             'avail_blocks': s.avail_blocks,
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
             'duplex': s.duplex,
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

def py_sg_get_process_stats():
    cdef sg_process_stats *s
    cdef int entries
    s = sg_get_process_stats(&entries)
    if s == NULL:
        raise StatgrabException, 'sg_get_process_stats() returned NULL'
    list = []
    for i from 0 <= i < entries:
        if s.process_name is NULL:
            process_name = ''
        else:
            process_name = s.process_name
        if s.proctitle is NULL:
            proctitle = ''
        else:
            proctitle = s.proctitle
        list.append(Result(
            {'process_name': process_name,
             'proctitle' : proctitle,
             'pid' : s.pid,
             'parent' : s.parent,
             'pgid' : s.pgid,
             'uid' : s.uid,
             'euid' : s.euid,
             'gid' : s.gid,
             'egid' : s.egid,
             'proc_size' : s.proc_size,
             'proc_resident' : s.proc_resident,
             'time_spent' : s.time_spent,
             'cpu_percent' : s.cpu_percent,
             'nice' : s.nice,
             'state' : s.state,
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
