#!/bin/bash
#
# SCRIPTrunner
#
# This is called by the cockpit webui to run scripts, it should only ever run 
# scripts from the scripts directory and should sanitize the input
#

#set -u -x

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

PREFIX=
SUFFIX=.sh
SCRIPT="${1}"
VALUE="${2:-}"

# check for static type
TYPE=$(echo $SCRIPT | cut -c1-2)
case ${TYPE} in
    s-)
        # STATIC
        SCDIR="${SCDIR}/static"
        SCRIPT=$( echo $SCRIPT | cut -c3-)
        ;;
    d-)
        # DIALOGS
        SCDIR="${DIDIR}"
        SCRIPT=$( echo $SCRIPT | cut -c3-)
        ;;
    *)
        # EVERYTHING ELSE
        ;;
esac

## make this better
SANITIZED=$(echo "${SCRIPT}" | sed 's/[\.;]//g')

# build script name
SCRIPT="${PREFIX}${SANITIZED}${SUFFIX}"

cd "${SCDIR}"

[ -z "${1}" ] && echo "No options passed" && exit 1
[ ! -f ${SCRIPT} ] && echo "Failed to find script for $1" && exit 1
[ -z ${SCDIR} ] && echo "SCDIR cannot be empty, something is terribly wrong" && exit 2

shift
# this can be abused, find a better option
bash ${SCDIR}/${SCRIPT} $* 2>&1
