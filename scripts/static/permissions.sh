#!/bin/bash
#
# This should mimic the old dialog and let the user select a folder
#
#set -x

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

sudo chown -Rc ${OLDRNUSER}:${OLDRNUSER} "${OLDRNPATH}"
sudo chmod -Rc a-st,u+rwX,g+rwX,o+rX "${OLDRNPATH}"

echo "Done, if there was anything to do output will be listed above"

PAUSE