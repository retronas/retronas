#!/bin/bash

#set -x

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

sudo chown -Rc ${OLDRNUSER}:${OLDRNUSER} "${OLDRNPATH}"
sudo chmod -Rc a-st,u+rwX,g+rwX,o+rX "${OLDRNPATH}"