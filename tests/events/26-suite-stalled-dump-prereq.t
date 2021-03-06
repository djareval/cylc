#!/bin/bash
# THIS FILE IS PART OF THE CYLC SUITE ENGINE.
# Copyright (C) 2008-2017 NIWA
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#-------------------------------------------------------------------------------
# Test suite event handler, dump unmet prereqs on stall
. "$(dirname "$0")/test_header"
set_test_number 8

install_suite "${TEST_NAME_BASE}" "${TEST_NAME_BASE}"
run_ok "${TEST_NAME_BASE}-validate" \
    cylc validate "${SUITE_NAME}"
suite_run_fail "${TEST_NAME_BASE}-run" \
    cylc run --reference-test --debug "${SUITE_NAME}"
grep_ok "Abort on suite stalled is set" \
    "${TEST_NAME_BASE}-run.stderr"
grep_ok "WARNING - Unmet prerequisites for foo.20100101T0600Z:" \
    "${TEST_NAME_BASE}-run.stderr"
grep_ok "WARNING -  \\* bar.20100101T0000Z succeeded" \
    "${TEST_NAME_BASE}-run.stderr"
grep_ok "WARNING - Unmet prerequisites for qux.20100101T0000Z:" \
    "${TEST_NAME_BASE}-run.stderr"
grep_ok "WARNING - Unmet prerequisites for baz.20100101T1200Z:" \
    "${TEST_NAME_BASE}-run.stderr"
grep_ok "WARNING -  \\* qux.20100101T0600Z succeeded" \
    "${TEST_NAME_BASE}-run.stderr"

purge_suite "${SUITE_NAME}"
exit
