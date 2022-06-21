#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

CHECK_GROUP_EXISTS() {
    local NEWRNGROUP=$1
    local OLDRNGROUP=$2

}


UPDATE_GROUP() {

}


CHECK_GROUP $NEWRNGROUP $OLDRNGROUP