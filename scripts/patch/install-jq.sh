#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

# jq, kept here to handle migration to new menu system
if [ ! -f /usr/bin/jq ] 
then
  CHECK_PACKAGE_CACHE
  apt-get -y install jq
  [ $? -ne 0 ] && PAUSE && EXIT_CANCEL
fi