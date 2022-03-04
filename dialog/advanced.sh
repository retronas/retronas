#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=advanced
cd ${DIDIR}
CHOICE=""

rn_advanced() {

  READ_MENU_JSON "${MENU_NAME}"
  local MENU_BLURB="\nPlease select an tool to install" 
  DLG_MENUJ "Advanced Menu" 10 "${MENU_BLURB}"

}

DROP_ROOT
CLEAR

while true
do
  rn_advanced
  if [ ! -z "${CHOICE}" ]
  then
    READ_MENU_COMMAND ${MENU_NAME} ${CHOICE} 
  else
    exit 1
  fi
done
