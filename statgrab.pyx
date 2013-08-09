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

ctypedef long time_t
ctypedef int pid_t
ctypedef int uid_t
ctypedef int gid_t

cdef extern from "statgrab.h":
    ctypedef enum sg_error:
        SG_ERROR_NONE = 0
        SG_ERROR_INVALID_ARGUMENT
        SG_ERROR_ASPRINTF
        SG_ERROR_SPRINTF
        SG_ERROR_DEVICES
        SG_ERROR_DEVSTAT_GETDEVS
        SG_ERROR_DEVSTAT_SELECTDEVS
        SG_ERROR_DISKINFO
        SG_ERROR_ENOENT
        SG_ERROR_GETIFADDRS
        SG_ERROR_GETMNTINFO
        SG_ERROR_GETPAGESIZE
        SG_ERROR_HOST
        SG_ERROR_KSTAT_DATA_LOOKUP
        SG_ERROR_KSTAT_LOOKUP
        SG_ERROR_KSTAT_OPEN
        SG_ERROR_KSTAT_READ
        SG_ERROR_KVM_GETSWAPINFO
        SG_ERROR_KVM_OPENFILES
        SG_ERROR_MALLOC
        SG_ERROR_MEMSTATUS
        SG_ERROR_OPEN
        SG_ERROR_OPENDIR
        SG_ERROR_READDIR
        SG_ERROR_PARSE
        SG_ERROR_PDHADD
        SG_ERROR_PDHCOLLECT
        SG_ERROR_PDHOPEN
        SG_ERROR_PDHREAD
        SG_ERROR_PERMISSION
        SG_ERROR_PSTAT
        SG_ERROR_SETEGID
        SG_ERROR_SETEUID
        SG_ERROR_SETMNTENT
        SG_ERROR_SOCKET
        SG_ERROR_SWAPCTL
        SG_ERROR_SYSCONF
        SG_ERROR_SYSCTL
        SG_ERROR_SYSCTLBYNAME
        SG_ERROR_SYSCTLNAMETOMIB
        SG_ERROR_SYSINFO
        SG_ERROR_MACHCALL
        SG_ERROR_IOKIT
        SG_ERROR_UNAME
        SG_ERROR_UNSUPPORTED
        SG_ERROR_XSW_VER_MISMATCH
        SG_ERROR_GETMSG
        SG_ERROR_PUTMSG
        SG_ERROR_INITIALISATION
        SG_ERROR_MUTEX_LOCK
        SG_ERROR_MUTEX_UNLOCK

    ctypedef struct sg_error_details:
        sg_error error
        int errno_value
        const char *error_arg

    sg_error sg_get_error()
    const char *sg_get_error_arg()
    int sg_get_error_errno()
    sg_error sg_get_error_details(sg_error_details *err_details)
    const char *sg_str_error(sg_error code)
    char *sg_strperror(char **buf, const sg_error_details * const err_details)

    sg_error sg_init(bint ignore_init_errors)
    sg_error sg_shutdown()
    sg_error sg_snapshot()
    sg_error sg_drop_privileges()

    # sg_get_nelements not wrapped -- sizes returned below
    # sg_free_stats_buf not wrapped -- used for sg_free_* macros

    sg_error sg_lock_mutex(const char *mutex_name)
    sg_error sg_unlock_mutex(const char *mutex_name)

    ctypedef enum sg_host_state:
        sg_unknown_configuration = 0
        sg_physical_host
        sg_virtual_machine
        sg_paravirtual_machine
        sg_hardware_virtualized

    ctypedef struct sg_host_info:
        char *os_name
        char *os_release
        char *os_version
        char *platform
        char *hostname
        unsigned bitwidth
        sg_host_state host_state
        unsigned ncpus
        unsigned maxcpus
        time_t uptime
        time_t systime

    sg_host_info *sg_get_host_info(size_t *entries)
    sg_host_info *sg_get_host_info_r(size_t *entries)
    sg_error sg_free_host_info(sg_host_info *stats)

    ctypedef struct sg_cpu_stats:
        unsigned long long user
        unsigned long long kernel
        unsigned long long idle
        unsigned long long iowait
        unsigned long long swap
        unsigned long long nice
        unsigned long long total

        unsigned long long context_switches
        unsigned long long voluntary_context_switches
        unsigned long long involuntary_context_switches
        unsigned long long syscalls
        unsigned long long interrupts
        unsigned long long soft_interrupts

        time_t systime

    sg_cpu_stats *sg_get_cpu_stats(size_t *entries)
    sg_cpu_stats *sg_get_cpu_stats_diff(size_t *entries)
    sg_cpu_stats *sg_get_cpu_stats_r(size_t *entries)
    sg_cpu_stats *sg_get_cpu_stats_diff_between(const sg_cpu_stats *cpu_now, const sg_cpu_stats *cpu_last, size_t *entries)
    sg_error sg_free_cpu_stats(sg_cpu_stats *stats)

    ctypedef struct sg_cpu_percents:
        double user
        double kernel
        double idle
        double iowait
        double swap
        double nice
        time_t time_taken

    ctypedef enum sg_cpu_percent_source:
        sg_entire_cpu_percent
        sg_last_diff_cpu_percent
        sg_new_diff_cpu_percent

    sg_cpu_percents *sg_get_cpu_percents_of(sg_cpu_percent_source cps, size_t *entries)
    sg_cpu_percents *sg_get_cpu_percents_r(sg_cpu_stats *whereof, size_t *entries)
    sg_cpu_percents *sg_get_cpu_percents(size_t *entries)
    sg_error sg_free_cpu_percents(sg_cpu_percents *stats)

    ctypedef struct sg_mem_stats:
        unsigned long long total
        unsigned long long free
        unsigned long long used
        unsigned long long cache
        time_t systime

    sg_mem_stats *sg_get_mem_stats(size_t *entries)
    sg_mem_stats *sg_get_mem_stats_r(size_t *entries)
    sg_error sg_free_mem_stats(sg_mem_stats *stats)

    ctypedef struct sg_load_stats:
        double min1
        double min5
        double min15
        time_t systime

    sg_load_stats *sg_get_load_stats(size_t *entries)
    sg_load_stats *sg_get_load_stats_r(size_t *entries)
    sg_error sg_free_load_stats(sg_load_stats *stats)

    ctypedef struct sg_user_stats:
        char *login_name
        char *record_id
        size_t record_id_size
        char *device
        char *hostname
        pid_t pid
        time_t login_time
        time_t systime

    sg_user_stats *sg_get_user_stats(size_t *entries)
    sg_user_stats *sg_get_user_stats_r(size_t *entries)
    sg_error sg_free_user_stats(sg_user_stats *stats)

    ctypedef struct sg_swap_stats:
        long long total
        long long used
        long long free
        time_t systime

    sg_swap_stats *sg_get_swap_stats(size_t *entries)
    sg_swap_stats *sg_get_swap_stats_r(size_t *entries)
    sg_error sg_free_swap_stats(sg_swap_stats *stats)

    ctypedef enum sg_fs_device_type:
        sg_fs_unknown = 0
        sg_fs_regular = 1 << 0
        sg_fs_special = 1 << 1
        sg_fs_loopback = 1 << 2
        sg_fs_remote = 1 << 3
        sg_fs_local = (sg_fs_regular | sg_fs_special)
        sg_fs_alltypes = (sg_fs_regular | sg_fs_special | sg_fs_loopback | sg_fs_remote)

    ctypedef struct sg_fs_stats:
        char *device_name
        char *fs_type
        char *mnt_point
        sg_fs_device_type device_type
        unsigned long long size
        unsigned long long used
        unsigned long long free
        unsigned long long avail
        unsigned long long total_inodes
        unsigned long long used_inodes
        unsigned long long free_inodes
        unsigned long long avail_inodes
        unsigned long long io_size
        unsigned long long block_size
        unsigned long long total_blocks
        unsigned long long free_blocks
        unsigned long long used_blocks
        unsigned long long avail_blocks
        time_t systime

    const char **sg_get_valid_filesystems(size_t *entries)
    sg_error sg_set_valid_filesystems(const char *valid_fs[])

    sg_fs_stats *sg_get_fs_stats(size_t *entries)
    sg_fs_stats *sg_get_fs_stats_r(size_t *entries)
    sg_fs_stats *sg_get_fs_stats_diff(size_t *entries)
    sg_fs_stats *sg_get_fs_stats_diff_between(const sg_fs_stats *cur, const sg_fs_stats *last, size_t *entries)
    sg_error sg_free_fs_stats(sg_fs_stats *stats)

    # sg_fs_compare_device_name not wrapped - not needed
    # sg_fs_compare_mnt_point not wrapped - not needed

    ctypedef struct sg_disk_io_stats:
        char *disk_name
        unsigned long long read_bytes
        unsigned long long write_bytes
        time_t systime

    sg_disk_io_stats *sg_get_disk_io_stats(size_t *entries)
    sg_disk_io_stats *sg_get_disk_io_stats_r(size_t *entries)
    sg_disk_io_stats *sg_get_disk_io_stats_diff(size_t *entries)
    sg_disk_io_stats *sg_get_disk_io_stats_diff_between(const sg_disk_io_stats *cur, const sg_disk_io_stats *last, size_t *entries)
    sg_error sg_free_disk_io_stats(sg_disk_io_stats *stats)

    # sg_disk_io_compare_name not wrapped - not needed
    # sg_disk_io_compare_traffic not wrapped - not needed

    ctypedef struct sg_network_io_stats:
        char *interface_name
        unsigned long long tx
        unsigned long long rx
        unsigned long long ipackets
        unsigned long long opackets
        unsigned long long ierrors
        unsigned long long oerrors
        unsigned long long collisions
        time_t systime

    sg_network_io_stats *sg_get_network_io_stats(size_t *entries)
    sg_network_io_stats *sg_get_network_io_stats_r(size_t *entries)
    sg_network_io_stats *sg_get_network_io_stats_diff(size_t *entries)
    sg_network_io_stats *sg_get_network_io_stats_diff_between(const sg_network_io_stats *cur, const sg_network_io_stats *last, size_t *entries)
    sg_error sg_free_network_io_stats(sg_network_io_stats *stats)

    # sg_network_io_compare_name not wrapped - not needed

    ctypedef enum sg_iface_duplex:
        SG_IFACE_DUPLEX_FULL
        SG_IFACE_DUPLEX_HALF
        SG_IFACE_DUPLEX_UNKNOWN

    ctypedef enum sg_iface_updown:
        SG_IFACE_DOWN = 0
        SG_IFACE_UP

    ctypedef struct sg_network_iface_stats:
        char *interface_name
        unsigned long long speed
        unsigned long long factor
        sg_iface_duplex duplex
        sg_iface_updown up
        time_t systime

    sg_network_iface_stats *sg_get_network_iface_stats(size_t *entries)
    sg_network_iface_stats *sg_get_network_iface_stats_r(size_t *entries)
    sg_error sg_free_network_iface_stats(sg_network_iface_stats *stats)

    # sg_network_iface_compare_name not wrapped - not needed

    ctypedef struct sg_page_stats:
        unsigned long long pages_pagein
        unsigned long long pages_pageout
        time_t systime

    sg_page_stats *sg_get_page_stats(size_t *entries)
    sg_page_stats *sg_get_page_stats_r(size_t *entries)
    sg_page_stats *sg_get_page_stats_diff(size_t *entries)
    sg_page_stats *sg_get_page_stats_diff_between(const sg_page_stats *now, const sg_page_stats *last, size_t *entries)
    sg_error sg_free_page_stats(sg_page_stats *stats)

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
        pid_t sessid

        uid_t uid
        uid_t euid
        gid_t gid
        gid_t egid

        unsigned long long context_switches
        unsigned long long voluntary_context_switches
        unsigned long long involuntary_context_switches
        unsigned long long proc_size
        unsigned long long proc_resident
        time_t start_time
        time_t time_spent
        double cpu_percent
        int nice
        sg_process_state state

        time_t systime

    sg_process_stats *sg_get_process_stats(size_t *entries)
    sg_process_stats *sg_get_process_stats_r(size_t *entries)
    sg_error sg_free_process_stats(sg_process_stats *stats)

    # sg_process_compare_name not wrapped - not needed
    # sg_process_compare_pid not wrapped - not needed
    # sg_process_compare_uid not wrapped - not needed
    # sg_process_compare_gid not wrapped - not needed
    # sg_process_compare_size not wrapped - not needed
    # sg_process_compare_res not wrapped - not needed
    # sg_process_compare_cpu not wrapped - not needed
    # sg_process_compare_time not wrapped - not needed

    ctypedef struct sg_process_count:
        unsigned long long total
        unsigned long long running
        unsigned long long sleeping
        unsigned long long stopped
        unsigned long long zombie
        unsigned long long unknown
        time_t systime

    ctypedef enum sg_process_count_source:
        sg_entire_process_count
        sg_last_process_count

    sg_process_count *sg_get_process_count_of(sg_process_count_source pcs)
    sg_process_count *sg_get_process_count_r(sg_process_stats *whereof)
    sg_process_count *sg_get_process_count()
    sg_error sg_free_process_count(sg_process_count *stats)

# libstatgrab constants exported

ERROR_NONE = SG_ERROR_NONE
ERROR_INVALID_ARGUMENT = SG_ERROR_INVALID_ARGUMENT
ERROR_ASPRINTF = SG_ERROR_ASPRINTF
ERROR_SPRINTF = SG_ERROR_SPRINTF
ERROR_DEVICES = SG_ERROR_DEVICES
ERROR_DEVSTAT_GETDEVS = SG_ERROR_DEVSTAT_GETDEVS
ERROR_DEVSTAT_SELECTDEVS = SG_ERROR_DEVSTAT_SELECTDEVS
ERROR_DISKINFO = SG_ERROR_DISKINFO
ERROR_ENOENT = SG_ERROR_ENOENT
ERROR_GETIFADDRS = SG_ERROR_GETIFADDRS
ERROR_GETMNTINFO = SG_ERROR_GETMNTINFO
ERROR_GETPAGESIZE = SG_ERROR_GETPAGESIZE
ERROR_HOST = SG_ERROR_HOST
ERROR_KSTAT_DATA_LOOKUP = SG_ERROR_KSTAT_DATA_LOOKUP
ERROR_KSTAT_LOOKUP = SG_ERROR_KSTAT_LOOKUP
ERROR_KSTAT_OPEN = SG_ERROR_KSTAT_OPEN
ERROR_KSTAT_READ = SG_ERROR_KSTAT_READ
ERROR_KVM_GETSWAPINFO = SG_ERROR_KVM_GETSWAPINFO
ERROR_KVM_OPENFILES = SG_ERROR_KVM_OPENFILES
ERROR_MALLOC = SG_ERROR_MALLOC
ERROR_MEMSTATUS = SG_ERROR_MEMSTATUS
ERROR_OPEN = SG_ERROR_OPEN
ERROR_OPENDIR = SG_ERROR_OPENDIR
ERROR_READDIR = SG_ERROR_READDIR
ERROR_PARSE = SG_ERROR_PARSE
ERROR_PDHADD = SG_ERROR_PDHADD
ERROR_PDHCOLLECT = SG_ERROR_PDHCOLLECT
ERROR_PDHOPEN = SG_ERROR_PDHOPEN
ERROR_PDHREAD = SG_ERROR_PDHREAD
ERROR_PERMISSION = SG_ERROR_PERMISSION
ERROR_PSTAT = SG_ERROR_PSTAT
ERROR_SETEGID = SG_ERROR_SETEGID
ERROR_SETEUID = SG_ERROR_SETEUID
ERROR_SETMNTENT = SG_ERROR_SETMNTENT
ERROR_SOCKET = SG_ERROR_SOCKET
ERROR_SWAPCTL = SG_ERROR_SWAPCTL
ERROR_SYSCONF = SG_ERROR_SYSCONF
ERROR_SYSCTL = SG_ERROR_SYSCTL
ERROR_SYSCTLBYNAME = SG_ERROR_SYSCTLBYNAME
ERROR_SYSCTLNAMETOMIB = SG_ERROR_SYSCTLNAMETOMIB
ERROR_SYSINFO = SG_ERROR_SYSINFO
ERROR_MACHCALL = SG_ERROR_MACHCALL
ERROR_IOKIT = SG_ERROR_IOKIT
ERROR_UNAME = SG_ERROR_UNAME
ERROR_UNSUPPORTED = SG_ERROR_UNSUPPORTED
ERROR_XSW_VER_MISMATCH = SG_ERROR_XSW_VER_MISMATCH
ERROR_GETMSG = SG_ERROR_GETMSG
ERROR_PUTMSG = SG_ERROR_PUTMSG
ERROR_INITIALISATION = SG_ERROR_INITIALISATION
ERROR_MUTEX_LOCK = SG_ERROR_MUTEX_LOCK
ERROR_MUTEX_UNLOCK = SG_ERROR_MUTEX_UNLOCK

entire_cpu_percent = sg_entire_cpu_percent
last_diff_cpu_percent = sg_last_diff_cpu_percent
new_diff_cpu_percent = sg_new_diff_cpu_percent

IFACE_DUPLEX_FULL = SG_IFACE_DUPLEX_FULL
IFACE_DUPLEX_HALF = SG_IFACE_DUPLEX_HALF
IFACE_DUPLEX_UNKNOWN = SG_IFACE_DUPLEX_UNKNOWN

IFACE_DOWN = SG_IFACE_DOWN
IFACE_UP = SG_IFACE_UP

PROCESS_STATE_RUNNING = SG_PROCESS_STATE_RUNNING
PROCESS_STATE_SLEEPING = SG_PROCESS_STATE_SLEEPING
PROCESS_STATE_STOPPED = SG_PROCESS_STATE_STOPPED
PROCESS_STATE_ZOMBIE = SG_PROCESS_STATE_ZOMBIE
PROCESS_STATE_UNKNOWN = SG_PROCESS_STATE_UNKNOWN

entire_process_count = sg_entire_process_count
last_process_count = sg_last_process_count

# Helper code

class StatgrabError(Exception):
    """Exception representing a libstatgrab error."""
    def __init__(self):
        cdef sg_error_details details
        sg_get_error_details(&details)
        self.error = details.error
        self.errno_value = details.errno_value
        self.error_arg = details.error_arg

        cdef char *msg = NULL
        sg_strperror(&msg, &details)
        super(StatgrabError, self).__init__("statgrab error: " + msg)
        free(msg)

cdef int _not_error(sg_error code) except -1:
    """Raise StatgrabError if code is not SG_ERROR_NONE."""
    if code != ERROR_NONE:
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

# libstatgrab functions exported

# FIXME: docstrings

def init(ignore_init_errors=False):
    _not_error(sg_init(ignore_init_errors))

def snapshot():
    _not_error(sg_snapshot())

def shutdown():
    _not_error(sg_shutdown())

def drop_privileges():
    _not_error(sg_drop_privileges())

def get_host_info():
    cdef const sg_host_info *s = sg_get_host_info(NULL)
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

cdef _make_cpu_stats(const sg_cpu_stats *s):
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
    cdef const sg_cpu_stats *s = sg_get_cpu_stats(NULL)
    _not_null(s)
    return _make_cpu_stats(s)

def get_cpu_stats_diff():
    cdef const sg_cpu_stats *s = sg_get_cpu_stats_diff(NULL)
    _not_null(s)
    return _make_cpu_stats(s)

def get_cpu_percents(cps=new_diff_cpu_percent):
    cdef const sg_cpu_percents *s = sg_get_cpu_percents(NULL)
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
    cdef const sg_mem_stats *s = sg_get_mem_stats(NULL)
    _not_null(s)
    return Result({
        'total': s.total,
        'free': s.free,
        'used': s.used,
        'cache': s.cache,
        'systime': s.systime,
        })

def get_load_stats():
    cdef const sg_load_stats *s = sg_get_load_stats(NULL)
    _not_null(s)
    return Result({
        'min1': s.min1,
        'min5': s.min5,
        'min15': s.min15,
        'systime': s.systime,
        })

cdef _make_user_stats(const sg_user_stats *s):
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
    cdef const sg_user_stats *s = sg_get_user_stats(&n)
    _not_null(s)
    return [_make_user_stats(&s[i]) for i in range(n)]

def get_swap_stats():
    cdef const sg_swap_stats *s = sg_get_swap_stats(NULL)
    _not_null(s)
    return Result({
        'total': s.total,
        'used': s.used,
        'free': s.free,
        'systime': s.systime,
        })

def get_valid_filesystems():
    cdef size_t n
    cdef const char **s = sg_get_valid_filesystems(&n)
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
    _not_error(sg_set_valid_filesystems(vs))
    free(vs)

cdef _make_fs_stats(const sg_fs_stats *s):
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
    cdef const sg_fs_stats *s = sg_get_fs_stats(&n)
    _not_null(s)
    return [_make_fs_stats(&s[i]) for i in range(n)]

def get_fs_stats_diff():
    cdef size_t n
    cdef const sg_fs_stats *s = sg_get_fs_stats_diff(&n)
    _not_null(s)
    return [_make_fs_stats(&s[i]) for i in range(n)]

cdef _make_disk_io_stats(const sg_disk_io_stats *s):
    return Result({
        'disk_name': s.disk_name,
        'read_bytes': s.read_bytes,
        'write_bytes': s.write_bytes,
        'systime': s.systime,
    })

def get_disk_io_stats():
    cdef size_t n
    cdef const sg_disk_io_stats *s = sg_get_disk_io_stats(&n)
    _not_null(s)
    return [_make_disk_io_stats(&s[i]) for i in range(n)]

def get_disk_io_stats_diff():
    cdef size_t n
    cdef const sg_disk_io_stats *s = sg_get_disk_io_stats_diff(&n)
    _not_null(s)
    return [_make_disk_io_stats(&s[i]) for i in range(n)]

cdef _make_network_io_stats(const sg_network_io_stats *s):
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
    cdef const sg_network_io_stats *s = sg_get_network_io_stats(&n)
    _not_null(s)
    return [_make_network_io_stats(&s[i]) for i in range(n)]

def get_network_io_stats_diff():
    cdef size_t n
    cdef const sg_network_io_stats *s = sg_get_network_io_stats_diff(&n)
    _not_null(s)
    return [_make_network_io_stats(&s[i]) for i in range(n)]

cdef _make_network_iface_stats(const sg_network_iface_stats *s):
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
    cdef const sg_network_iface_stats *s = sg_get_network_iface_stats(&n)
    _not_null(s)
    return [_make_network_iface_stats(&s[i]) for i in range(n)]

cdef _make_page_stats(const sg_page_stats *s):
    return Result({
        'pages_pagein': s.pages_pagein,
        'pages_pageout': s.pages_pageout,
        'systime': s.systime,
        })

def get_page_stats():
    cdef const sg_page_stats *s = sg_get_page_stats(NULL)
    _not_null(s)
    return _make_page_stats(s)

def get_page_stats_diff():
    cdef const sg_page_stats *s = sg_get_page_stats_diff(NULL)
    _not_null(s)
    return _make_page_stats(s)

cdef _make_process_stats(const sg_process_stats *s):
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
    cdef const sg_process_stats *s = sg_get_process_stats(&n)
    _not_null(s)
    return [_make_process_stats(&s[i]) for i in range(n)]

def get_process_count(pcs=entire_process_count):
    cdef const sg_process_count *s = sg_get_process_count_of(pcs)
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
