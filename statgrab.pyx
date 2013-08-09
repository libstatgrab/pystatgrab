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

from libc.stdlib cimport malloc, free

cimport libstatgrab as sg

# Helper code

class StatgrabError(Exception):
    """Exception representing a libstatgrab error."""
    def __init__(self):
        cdef sg.sg_error_details details
        sg.sg_get_error_details(&details)
        self.error = details.error
        self.errno_value = details.errno_value
        self.error_arg = details.error_arg

        cdef char *msg = NULL
        sg.sg_strperror(&msg, &details)
        super(StatgrabError, self).__init__("statgrab error: " + msg)
        free(msg)

cdef int _not_error(sg.sg_error code) except -1:
    """Raise StatgrabError if code is not SG_ERROR_NONE."""
    if code != sg.SG_ERROR_NONE:
        raise StatgrabError()
    return 0

cdef int _not_null(const void *value) except -1:
    """Raise StatgrabError if value is NULL."""
    if value == NULL:
        raise StatgrabError()
    return 0

class Result(dict):
    def __init__(self, attrs):
        super(Result, self).__init__(attrs)

        # For compatibility with older pystatgrab.
        self.attrs = attrs

    def __getattr__(self, item):
        try:
            return self.__getitem__(item)
        except KeyError:
            raise AttributeError(item)

# libstatgrab constants exported

ERROR_NONE = sg.SG_ERROR_NONE
ERROR_INVALID_ARGUMENT = sg.SG_ERROR_INVALID_ARGUMENT
ERROR_ASPRINTF = sg.SG_ERROR_ASPRINTF
ERROR_SPRINTF = sg.SG_ERROR_SPRINTF
ERROR_DEVICES = sg.SG_ERROR_DEVICES
ERROR_DEVSTAT_GETDEVS = sg.SG_ERROR_DEVSTAT_GETDEVS
ERROR_DEVSTAT_SELECTDEVS = sg.SG_ERROR_DEVSTAT_SELECTDEVS
ERROR_DISKINFO = sg.SG_ERROR_DISKINFO
ERROR_ENOENT = sg.SG_ERROR_ENOENT
ERROR_GETIFADDRS = sg.SG_ERROR_GETIFADDRS
ERROR_GETMNTINFO = sg.SG_ERROR_GETMNTINFO
ERROR_GETPAGESIZE = sg.SG_ERROR_GETPAGESIZE
ERROR_HOST = sg.SG_ERROR_HOST
ERROR_KSTAT_DATA_LOOKUP = sg.SG_ERROR_KSTAT_DATA_LOOKUP
ERROR_KSTAT_LOOKUP = sg.SG_ERROR_KSTAT_LOOKUP
ERROR_KSTAT_OPEN = sg.SG_ERROR_KSTAT_OPEN
ERROR_KSTAT_READ = sg.SG_ERROR_KSTAT_READ
ERROR_KVM_GETSWAPINFO = sg.SG_ERROR_KVM_GETSWAPINFO
ERROR_KVM_OPENFILES = sg.SG_ERROR_KVM_OPENFILES
ERROR_MALLOC = sg.SG_ERROR_MALLOC
ERROR_MEMSTATUS = sg.SG_ERROR_MEMSTATUS
ERROR_OPEN = sg.SG_ERROR_OPEN
ERROR_OPENDIR = sg.SG_ERROR_OPENDIR
ERROR_READDIR = sg.SG_ERROR_READDIR
ERROR_PARSE = sg.SG_ERROR_PARSE
ERROR_PDHADD = sg.SG_ERROR_PDHADD
ERROR_PDHCOLLECT = sg.SG_ERROR_PDHCOLLECT
ERROR_PDHOPEN = sg.SG_ERROR_PDHOPEN
ERROR_PDHREAD = sg.SG_ERROR_PDHREAD
ERROR_PERMISSION = sg.SG_ERROR_PERMISSION
ERROR_PSTAT = sg.SG_ERROR_PSTAT
ERROR_SETEGID = sg.SG_ERROR_SETEGID
ERROR_SETEUID = sg.SG_ERROR_SETEUID
ERROR_SETMNTENT = sg.SG_ERROR_SETMNTENT
ERROR_SOCKET = sg.SG_ERROR_SOCKET
ERROR_SWAPCTL = sg.SG_ERROR_SWAPCTL
ERROR_SYSCONF = sg.SG_ERROR_SYSCONF
ERROR_SYSCTL = sg.SG_ERROR_SYSCTL
ERROR_SYSCTLBYNAME = sg.SG_ERROR_SYSCTLBYNAME
ERROR_SYSCTLNAMETOMIB = sg.SG_ERROR_SYSCTLNAMETOMIB
ERROR_SYSINFO = sg.SG_ERROR_SYSINFO
ERROR_MACHCALL = sg.SG_ERROR_MACHCALL
ERROR_IOKIT = sg.SG_ERROR_IOKIT
ERROR_UNAME = sg.SG_ERROR_UNAME
ERROR_UNSUPPORTED = sg.SG_ERROR_UNSUPPORTED
ERROR_XSW_VER_MISMATCH = sg.SG_ERROR_XSW_VER_MISMATCH
ERROR_GETMSG = sg.SG_ERROR_GETMSG
ERROR_PUTMSG = sg.SG_ERROR_PUTMSG
ERROR_INITIALISATION = sg.SG_ERROR_INITIALISATION
ERROR_MUTEX_LOCK = sg.SG_ERROR_MUTEX_LOCK
ERROR_MUTEX_UNLOCK = sg.SG_ERROR_MUTEX_UNLOCK

entire_cpu_percent = sg.sg_entire_cpu_percent
last_diff_cpu_percent = sg.sg_last_diff_cpu_percent
new_diff_cpu_percent = sg.sg_new_diff_cpu_percent

IFACE_DUPLEX_FULL = sg.SG_IFACE_DUPLEX_FULL
IFACE_DUPLEX_HALF = sg.SG_IFACE_DUPLEX_HALF
IFACE_DUPLEX_UNKNOWN = sg.SG_IFACE_DUPLEX_UNKNOWN

IFACE_DOWN = sg.SG_IFACE_DOWN
IFACE_UP = sg.SG_IFACE_UP

PROCESS_STATE_RUNNING = sg.SG_PROCESS_STATE_RUNNING
PROCESS_STATE_SLEEPING = sg.SG_PROCESS_STATE_SLEEPING
PROCESS_STATE_STOPPED = sg.SG_PROCESS_STATE_STOPPED
PROCESS_STATE_ZOMBIE = sg.SG_PROCESS_STATE_ZOMBIE
PROCESS_STATE_UNKNOWN = sg.SG_PROCESS_STATE_UNKNOWN

entire_process_count = sg.sg_entire_process_count
last_process_count = sg.sg_last_process_count

# libstatgrab functions exported

# FIXME: docstrings

def init(ignore_init_errors=False):
    _not_error(sg.sg_init(ignore_init_errors))

def snapshot():
    _not_error(sg.sg_snapshot())

def shutdown():
    _not_error(sg.sg_shutdown())

def drop_privileges():
    _not_error(sg.sg_drop_privileges())

def get_host_info():
    cdef const sg.sg_host_info *s = sg.sg_get_host_info(NULL)
    _not_null(s)
    return Result({
        'os_name': s.os_name,
        'os_release': s.os_release,
        'os_version': s.os_version,
        'platform': s.platform,
        'hostname': s.hostname,
        'bitwidth': s.bitwidth,
        'host_state': s.host_state,
        'ncpus': s.ncpus,
        'maxcpus': s.maxcpus,
        'uptime': s.uptime,
        'systime': s.systime,
        })

cdef _make_cpu_stats(const sg.sg_cpu_stats *s):
    return Result({
        'user': s.user,
        'kernel': s.kernel,
        'idle': s.idle,
        'iowait': s.iowait,
        'swap': s.swap,
        'nice': s.nice,
        'total': s.total,
        'context_switches': s.context_switches,
        'voluntary_context_switches': s.voluntary_context_switches,
        'involuntary_context_switches': s.involuntary_context_switches,
        'syscalls': s.syscalls,
        'interrupts': s.interrupts,
        'soft_interrupts': s.soft_interrupts,
        'systime': s.systime,
        })

def get_cpu_stats():
    cdef const sg.sg_cpu_stats *s = sg.sg_get_cpu_stats(NULL)
    _not_null(s)
    return _make_cpu_stats(s)

def get_cpu_stats_diff():
    cdef const sg.sg_cpu_stats *s = sg.sg_get_cpu_stats_diff(NULL)
    _not_null(s)
    return _make_cpu_stats(s)

def get_cpu_percents(cps=new_diff_cpu_percent):
    cdef const sg.sg_cpu_percents *s = sg.sg_get_cpu_percents(NULL)
    _not_null(s)
    return Result({
        'user': s.user,
        'kernel': s.kernel,
        'idle': s.idle,
        'iowait': s.iowait,
        'swap': s.swap,
        'nice': s.nice,
        'time_taken': s.time_taken,
        })

def get_mem_stats():
    cdef const sg.sg_mem_stats *s = sg.sg_get_mem_stats(NULL)
    _not_null(s)
    return Result({
        'total': s.total,
        'free': s.free,
        'used': s.used,
        'cache': s.cache,
        'systime': s.systime,
        })

def get_load_stats():
    cdef const sg.sg_load_stats *s = sg.sg_get_load_stats(NULL)
    _not_null(s)
    return Result({
        'min1': s.min1,
        'min5': s.min5,
        'min15': s.min15,
        'systime': s.systime,
        })

cdef _make_user_stats(const sg.sg_user_stats *s):
    return Result({
        'login_name': s.login_name,
        # Note special handling for record_id.
        'record_id': s.record_id[:s.record_id_size],
        'device': s.device,
        'hostname': s.hostname,
        'pid': s.pid,
        'login_time': s.login_time,
        'systime': s.systime,
        })

def get_user_stats():
    cdef size_t n
    cdef const sg.sg_user_stats *s = sg.sg_get_user_stats(&n)
    _not_null(s)
    return [_make_user_stats(&s[i]) for i in range(n)]

def get_swap_stats():
    cdef const sg.sg_swap_stats *s = sg.sg_get_swap_stats(NULL)
    _not_null(s)
    return Result({
        'total': s.total,
        'used': s.used,
        'free': s.free,
        'systime': s.systime,
        })

def get_valid_filesystems():
    cdef size_t n
    cdef const char **s = sg.sg_get_valid_filesystems(&n)
    if s == NULL:
        print "argh"
    _not_null(s)
    return [s[i] for i in range(n)]

def set_valid_filesystems(valid_fs):
    cdef int num_fs = len(valid_fs)
    cdef const char **vs
    vs = <const char **>malloc((num_fs + 1) * sizeof(const char *))
    if vs == NULL:
        raise MemoryError("malloc failed")
    for i in range(num_fs):
        vs[i] = valid_fs[i]
    vs[num_fs] = NULL
    _not_error(sg.sg_set_valid_filesystems(vs))
    free(vs)

cdef _make_fs_stats(const sg.sg_fs_stats *s):
    return Result({
        'device_name': s.device_name,
        'fs_type': s.fs_type,
        'mnt_point': s.mnt_point,
        'device_type': s.device_type,
        'size': s.size,
        'used': s.used,
        'free': s.free,
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
        'systime': s.systime,
        })

def get_fs_stats():
    cdef size_t n
    cdef const sg.sg_fs_stats *s = sg.sg_get_fs_stats(&n)
    _not_null(s)
    return [_make_fs_stats(&s[i]) for i in range(n)]

def get_fs_stats_diff():
    cdef size_t n
    cdef const sg.sg_fs_stats *s = sg.sg_get_fs_stats_diff(&n)
    _not_null(s)
    return [_make_fs_stats(&s[i]) for i in range(n)]

cdef _make_disk_io_stats(const sg.sg_disk_io_stats *s):
    return Result({
        'disk_name': s.disk_name,
        'read_bytes': s.read_bytes,
        'write_bytes': s.write_bytes,
        'systime': s.systime,
    })

def get_disk_io_stats():
    cdef size_t n
    cdef const sg.sg_disk_io_stats *s = sg.sg_get_disk_io_stats(&n)
    _not_null(s)
    return [_make_disk_io_stats(&s[i]) for i in range(n)]

def get_disk_io_stats_diff():
    cdef size_t n
    cdef const sg.sg_disk_io_stats *s = sg.sg_get_disk_io_stats_diff(&n)
    _not_null(s)
    return [_make_disk_io_stats(&s[i]) for i in range(n)]

cdef _make_network_io_stats(const sg.sg_network_io_stats *s):
    return Result({
        'interface_name': s.interface_name,
        'tx': s.tx,
        'rx': s.rx,
        'ipackets': s.ipackets,
        'opackets': s.opackets,
        'ierrors': s.ierrors,
        'oerrors': s.oerrors,
        'collisions': s.collisions,
        'systime': s.systime,
        })

def get_network_io_stats():
    cdef size_t n
    cdef const sg.sg_network_io_stats *s = sg.sg_get_network_io_stats(&n)
    _not_null(s)
    return [_make_network_io_stats(&s[i]) for i in range(n)]

def get_network_io_stats_diff():
    cdef size_t n
    cdef const sg.sg_network_io_stats *s = sg.sg_get_network_io_stats_diff(&n)
    _not_null(s)
    return [_make_network_io_stats(&s[i]) for i in range(n)]

cdef _make_network_iface_stats(const sg.sg_network_iface_stats *s):
    return Result({
        'interface_name': s.interface_name,
        'speed': s.speed,
        'factor': s.factor,
        'duplex': s.duplex,
        'up': s.up,
        'systime': s.systime,
        })

def get_network_iface_stats():
    cdef size_t n
    cdef const sg.sg_network_iface_stats *s = sg.sg_get_network_iface_stats(&n)
    _not_null(s)
    return [_make_network_iface_stats(&s[i]) for i in range(n)]

cdef _make_page_stats(const sg.sg_page_stats *s):
    return Result({
        'pages_pagein': s.pages_pagein,
        'pages_pageout': s.pages_pageout,
        'systime': s.systime,
        })

def get_page_stats():
    cdef const sg.sg_page_stats *s = sg.sg_get_page_stats(NULL)
    _not_null(s)
    return _make_page_stats(s)

def get_page_stats_diff():
    cdef const sg.sg_page_stats *s = sg.sg_get_page_stats_diff(NULL)
    _not_null(s)
    return _make_page_stats(s)

cdef _make_process_stats(const sg.sg_process_stats *s):
    return Result({
        'process_name': s.process_name,
        'proctitle': s.proctitle,
        'pid': s.pid,
        'parent': s.parent,
        'pgid': s.pgid,
        'sessid': s.sessid,
        'uid': s.uid,
        'euid': s.euid,
        'gid': s.gid,
        'egid': s.egid,
        'context_switches': s.context_switches,
        'voluntary_context_switches': s.voluntary_context_switches,
        'involuntary_context_switches': s.involuntary_context_switches,
        'proc_size': s.proc_size,
        'proc_resident': s.proc_resident,
        'start_time': s.start_time,
        'time_spent': s.time_spent,
        'cpu_percent': s.cpu_percent,
        'nice': s.nice,
        'state': s.state,
        'systime': s.systime,
        })

def get_process_stats():
    cdef size_t n
    cdef const sg.sg_process_stats *s = sg.sg_get_process_stats(&n)
    _not_null(s)
    return [_make_process_stats(&s[i]) for i in range(n)]

def get_process_count(pcs=entire_process_count):
    cdef const sg.sg_process_count *s = sg.sg_get_process_count_of(pcs)
    _not_null(s)
    return Result({
        'total': s.total,
        'running': s.running,
        'sleeping': s.sleeping,
        'stopped': s.stopped,
        'zombie': s.zombie,
        'unknown': s.unknown,
        'systime': s.systime,
        })
