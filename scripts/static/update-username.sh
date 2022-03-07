#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

CHECK_USER_EXISTS() {
    local NEWRNUSER=$1
    local OLDRNUSER=$2

}


UPDATE_USERNAME() {

}


CHECK_USERNAME $NEWRNUSER $OLDRNUSER