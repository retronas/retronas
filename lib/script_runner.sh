#!/bin/bash
#
# SCRIPTrunner
#
# This is called by the cockpit webui to run scripts, it should only ever run 
# scripts from the scripts directory and should sanitize the input
#

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG

PREFIX=rn_
SUFFIX=.sh

## make this better
SANTIZED=$(echo "${1}" | sed 's/\.//g')

SCRIPT="${PREFIX}${SANITIZED}${SUFFIX}"

cd "${SCDIR}"

[ -z "${1}" ] && echo "No options passed" && exit 1
[ ! -f ${SCRIPT} ] && echo "Failed to find script for $1" && exit 1
${SCDIR}/${SCRIPT}
