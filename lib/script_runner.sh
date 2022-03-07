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
KEY="${1}"
VALUE="${2:-}"
X_SANITIZE=1

# check for static type
TYPE=$(echo $KEY | cut -c1-2)
case ${TYPE} in
    s-)
        # STATIC
        SCDIR="${SCDIR}/static"
        SCRIPT=$( echo $KEY | cut -c3-)
        ;;
    m-)
        # MODAL
        SCDIR="${DIDIR}"
        SCRIPT=$( echo $KEY | cut -c3-)
        ;;
    i-)
        # DIALOG (input)
        SCDIR="${DIDIR}"
        SCRIPT="d_input"
        X_SANITIZE=0
        VALUE=$( echo $KEY | cut -c3-)
        ;;
    d-)
        # DIALOGS (auto run)
        SCDIR="${DIDIR}"
        SCRIPT="d_menu"
        X_SANITIZE=0
        VALUE=$( echo $KEY | cut -c3-)
        ;;
    y-)
        # DIALOGS (yes/no)
        SCDIR="${DIDIR}"
        SCRIPT="d_yn"
        X_SANITIZE=0
        VALUE=$( echo $KEY | cut -c3-)
        ;;
    *)
        # EVERYTHING ELSE
        SCRIPT="${KEY}"
        ;;
esac

## make this better, its a hail mary anyway since the script is called from client-side
SANITIZED=$(echo "${SCRIPT}" | sed 's/[;]//g')

## ADDITIONAL
if [ $X_SANITIZE -eq 1 ]
then
    SANITIZED=$(echo "${SCRIPT}" | sed 's/[\.]//g')
fi

# build script name
SCRIPT="${PREFIX}${SANITIZED}${SUFFIX}"
cd "${SCDIR}"

[ -z "${1}" ] && echo "No options passed" && exit 1
[ ! -f ${SCRIPT} ] && echo "Failed to find script for ${SCRIPT}" && PAUSE && exit 1
[ -z ${SCDIR} ] && echo "SCDIR cannot be empty, something is terribly wrong" && exit 2

shift
# this can be abused, find a better option
bash ${SCDIR}/${SCRIPT} ${VALUE} $* 2>&1
