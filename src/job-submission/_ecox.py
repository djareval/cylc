#!/usr/bin/env python

import os, re

class ecox(object):
    def check( self, task_id, owner, dirs, ):
        # check the ecoconnect environment (devel, test, oper), modify
        # the task owner username appropriately, and (maybe) set some
        # default loadleveler directives).
        if not owner:
            raise SystemExit( "EcoConnect tasks require an owner: " + task_id )
        suite_owner = os.environ['USER']
        m = re.match( '^(.*)_(devel|test|oper)$', suite_owner )
        if m:
            (junk, ecoc_sys ) = m.groups()
        else:
            raise SystemExit( "EcoConnect suites must run in an EcoConnect environment" )
        # transform owner username for devel, test, or oper suites
        # strip off any existing suite suffix defined in the taskdef file
        m = re.match( '^(.*)_(devel|test|oper)$', owner )
        if m:
            ( owner_name, junk ) = m.groups()
        else:
            owner_name = owner
        owner = owner_name + '_' + ecoc_sys

        # NOT USING:
        #if 'class' not in dirs:
        #    # DEFAULT ECOCONNECT LOADLEVELER DIRECTIVES
        #    # dirs[ 'class'    ] = self.suite !!!! TO DO: WHEN FINAL LL CLASSES CONFIGURED
        #    dirs[ 'class' ] = 'test_linux'
        #    # (this changes the external dirs structure)

        return owner