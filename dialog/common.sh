#!/bin/bash

set -u

_CONFIG=/opt/retronas/dialog/retronas.cfg
source $_CONFIG

export SC="systemctl --no-pager --full"

## If this is run as root, switch to our RetroNAS user
## Manifests and cookies stored in ~/.gogrepo
DROP_ROOT() {
    if [ "${USER}" == "root" ]
    then
        export SUCOMMAND="sudo -u ${OLDRNUSER}"
    else
        export SUCOMMAND=""
    fi
}


### Get LANG file
GET_LANG() {
    [ ! -z "${LANG}" ] && RNLANG=$(echo $LANG | awk -F'_' '{print $1}')
    [ -z ${RNLANG} ] && RNLANG="en"
    
    if [ -f ${LANGDIR}/${RNLANG} ]
    then
        source ${LANGDIR}/${RNLANG}
    else
        echo "Failed to load language file, check config is complete"
        exit 1
    fi

}

PAUSE() {
    echo "${PAUSEMSG}"
    read -s
}