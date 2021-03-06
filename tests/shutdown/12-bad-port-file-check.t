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
# Test suite shuts down with error on missing port file
. "$(dirname "$0")/test_header"

set_test_number 3

OPT_SET=
if [[ "${TEST_NAME_BASE}" == *-globalcfg ]]; then
    create_test_globalrc "" "
[cylc]
    health check interval = PT10S"
    OPT_SET='-s GLOBALCFG=True'
fi

install_suite "${TEST_NAME_BASE}" "${TEST_NAME_BASE}"
run_ok "${TEST_NAME_BASE}-validate" cylc validate ${OPT_SET} "${SUITE_NAME}"
suite_run_fail "${TEST_NAME_BASE}-run" \
    cylc run --no-detach ${OPT_SET} "${SUITE_NAME}"
SRVD="$(cylc get-global-config --print-run-dir)/${SUITE_NAME}/.service"
LOGD="$(cylc get-global-config --print-run-dir)/${SUITE_NAME}/log"
grep_ok \
    "${SRVD}/contact: suite contact file corrupted/modified and may be left" \
    "${LOGD}/suite/log"
purge_suite "${SUITE_NAME}"
exit
