#!/bin/bash

set -ue

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

echo "Running Checks"
[ $OLDRNPATH == "/" ] && exit 1
[ ! -d $OLDRNPATH ] && echo "Path not found: $OLDRNPATH" && exit 1

echo "Starting scan"
find "$OLDRNPATH" -xtype l -exec rm "{}" \;

echo "Done"
PAUSE