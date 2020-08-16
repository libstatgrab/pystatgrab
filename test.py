#!/usr/bin/env python
#
# Test suite for pystatgrab
# https://libstatgrab.org/pystatgrab/
# Copyright (C) 2004-2019 Tim Bishop
# Copyright (C) 2005-2013 Adam Sampson
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

import statgrab
import unittest

class TestStartup(unittest.TestCase):
    def test_one_startup(self):
        statgrab.init()
        statgrab.shutdown()

    def test_ignore_errors(self):
        for v in (True, False):
            statgrab.init(v)
            statgrab.shutdown()

    def test_multi_startup(self):
        # We should be able to do this repeatedly.
        for i in range(10):
            statgrab.init()
            statgrab.shutdown()

# Not tested: snapshot - Win32 only
# Not tested: drop_privileges - you need to have privileges first

class StatgrabTestCase(unittest.TestCase):
    def setUp(self):
        statgrab.init()

    def tearDown(self):
        statgrab.shutdown()

class TestResults(StatgrabTestCase):
    def _one_result(self, func, *args):
        """Test a function that returns a single Result."""
        result = func(*args)
        self._check_result(result)
        return result

    def _list_result(self, func, *args):
        """Test a function that returns a list of Results."""
        results = func(*args)
        # Unfortunately we can't assume that the list won't be empty -- e.g. if
        # we're running on a machine with no network interfaces up...
        for result in results:
            self._check_result(result)
        return results

    def _check_result(self, result):
        """Check a Result."""
        self.assertTrue(isinstance(result, statgrab.Result))
        self.assertTrue(len(result.keys()) > 0)
        for key, value in result.items():
            # Check we can do something with the data.
            str(key)
            str(value)

    def test_host_info(self):
        self._one_result(statgrab.get_host_info)

    def test_cpu_stats(self):
        self._one_result(statgrab.get_cpu_stats)

    def test_cpu_stats_diff(self):
        self._one_result(statgrab.get_cpu_stats_diff)

    def test_cpu_percents(self):
        self._one_result(statgrab.get_cpu_percents)
        self._one_result(statgrab.get_cpu_percents,
                         statgrab.entire_cpu_percent)
        self._one_result(statgrab.get_cpu_percents,
                         statgrab.last_diff_cpu_percent)
        self._one_result(statgrab.get_cpu_percents,
                         statgrab.new_diff_cpu_percent)

    def test_mem_stats(self):
        self._one_result(statgrab.get_mem_stats)

    def test_load_stats(self):
        self._one_result(statgrab.get_load_stats)

    def test_user_stats(self):
        self._list_result(statgrab.get_user_stats)

    def test_swap_stats(self):
        self._one_result(statgrab.get_swap_stats)

    def test_fs_stats(self):
        self._list_result(statgrab.get_fs_stats)

    def test_fs_stats_diff(self):
        self._list_result(statgrab.get_fs_stats_diff)

    def test_disk_io_stats(self):
        self._list_result(statgrab.get_disk_io_stats)

    def test_disk_io_stats_diff(self):
        self._list_result(statgrab.get_disk_io_stats_diff)

    def test_network_io_stats(self):
        self._list_result(statgrab.get_network_io_stats)

    def test_network_io_stats_diff(self):
        self._list_result(statgrab.get_network_io_stats_diff)

    def test_network_iface_stats(self):
        duplexes = [
            statgrab.IFACE_DUPLEX_FULL,
            statgrab.IFACE_DUPLEX_HALF,
            statgrab.IFACE_DUPLEX_UNKNOWN,
            ]
        ups = [
            statgrab.IFACE_DOWN,
            statgrab.IFACE_UP,
            ]

        ifaces = self._list_result(statgrab.get_network_iface_stats)
        for iface in ifaces:
            self.assertTrue(iface.duplex in duplexes)
            self.assertTrue(iface.up in ups)

    def test_page_stats(self):
        self._one_result(statgrab.get_page_stats)

    def test_page_stats_diff(self):
        self._one_result(statgrab.get_page_stats_diff)

    def test_process_stats(self):
        self._list_result(statgrab.get_process_stats)

    def test_process_count(self):
        self._one_result(statgrab.get_process_count)
        self._one_result(statgrab.get_process_count,
                         statgrab.entire_process_count)
        self._one_result(statgrab.get_process_count,
                         statgrab.last_process_count)

class TestValidFS(StatgrabTestCase):
    def test_get(self):
        vfs = statgrab.get_valid_filesystems()
        self.assertTrue(isinstance(vfs, list))
        self.assertTrue(len(vfs) > 0)
        for s in vfs:
            self.assertTrue(isinstance(s, str))

    def test_set_existing(self):
        vfs1 = statgrab.get_valid_filesystems()
        statgrab.set_valid_filesystems(vfs1)
        vfs2 = statgrab.get_valid_filesystems()
        # The order can differ but the contents should be the same.
        self.assertEqual(sorted(vfs1), sorted(vfs2))

    def test_set_new(self):
        vfs1 = ["ext4", "notarealfs", "isofs"]
        statgrab.set_valid_filesystems(vfs1)
        vfs2 = statgrab.get_valid_filesystems()
        # The order can differ but the contents should be the same.
        self.assertEqual(sorted(vfs1), sorted(vfs2))

    def test_set_real(self):
        # Try to filter out some real filesystems.
        stats1 = statgrab.get_fs_stats()
        types = [st.fs_type for st in stats1]

        if len(types) < 2:
            # We have... 0 or 1 types of filesystem currently mounted?
            # Weird but possible, so just give up on this test.
            return

        # Try limiting results to just the first type.
        first = types[0]
        statgrab.set_valid_filesystems([first])

        stats2 = statgrab.get_fs_stats()
        self.assertTrue(len(stats2) < len(stats1))
        for st in stats2:
            self.assertEqual(st.fs_type, first)

    def test_set_empty(self):
        # This test also has the side-effect of testing that we're handling
        # empty vector results correctly.

        statgrab.set_valid_filesystems([])
        self.assertEqual(statgrab.get_valid_filesystems(), [])

        # If we set the list of valid filesystems to be empty, we shouldn't get
        # any filesystem results.
        self.assertEqual(len(statgrab.get_fs_stats()), 0)

class TestPre0_90(unittest.TestCase):
    def setUp(self):
        statgrab.sg_init()

    def tearDown(self):
        statgrab.sg_shutdown()

    def test_startup_shutdown(self):
        pass

    def test_error(self):
        self.assertEqual(statgrab.sg_get_error(), statgrab.SG_ERROR_NONE)
        s = statgrab.sg_str_error(statgrab.SG_ERROR_ENOENT)
        self.assertTrue(isinstance(s, str))

    def test_results(self):
        # Most of the sg_ functions are properly tested above, but check one of
        # them exists with the right name...
        host = statgrab.sg_get_host_info()
        self.assertTrue(isinstance(host, statgrab.Result))

    def test_user(self):
        # Check this returns the old-fashioned result.
        users = statgrab.sg_get_user_stats()
        self.assertTrue(isinstance(users, statgrab.Result))
        self.assertTrue(isinstance(users.name_list, str))

if __name__ == '__main__':
    unittest.main()
