#!/bin/bash

set -u

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
source /etc/os-release

CHECK_ROOT

case $ID in
    debian|ubuntu)
        more /var/log/apt/history.log
        PAUSE
        ;;
    *)
        echo "Unsupported OS type $ID"
        PAUSE
        EXIT_CANCEL
        ;;
esac