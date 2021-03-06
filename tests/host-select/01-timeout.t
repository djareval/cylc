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
# Test host selection, with a command that times out.
. "$(dirname "$0")/test_header"

set_test_number 3

install_suite "${TEST_NAME_BASE}" "${TEST_NAME_BASE}"

create_test_globalrc 'task host select command timeout = PT1S'
run_ok "${TEST_NAME_BASE}-validate" cylc validate "${SUITE_NAME}"
suite_run_ok "${TEST_NAME_BASE}" \
    cylc run --reference-test --debug "${SUITE_NAME}"
grep_ok 'ERROR: command timed out (>1s), terminated by signal 15' \
    "$(cylc get-global-config --print-run-dir)/${SUITE_NAME}/log/suite/err"
purge_suite "${SUITE_NAME}"
exit
