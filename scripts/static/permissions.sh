#!/bin/bash
#
# This should mimic the old dialog and let the user select a folder
#
#set -x
set -u

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

PROCSUB=${1:-all}

case $PROCSUB in
  all)
    PROCDIR="${OLDRNPATH}"
    ;;
  *)
    PROCDIR="${OLDRNPATH}/${PROCSUB}"
    ;;
esac

echo "Processing: ${PROCDIR}"

sudo chown -Rc ${OLDRNUSER}:${OLDRNGROUP} "${PROCDIR}"
sudo chmod -Rc a-st,u+rwX,g+rwX,o+rX "${PROCDIR}"

echo "Done, if there was anything to do output will be listed above"
