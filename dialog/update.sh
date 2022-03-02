#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=update
cd ${DIDIR}
CHOICE=""

rn_update() {

  READ_MENU_JSON "${MENU_NAME}"
  local MENU_BLURB="\nPlease select a tool to update" 
  DLG_MENUJ "Update Menu" 10 "${MENU_BLURB}"

}

DROP_ROOT
CLEAR

while true
do
  rn_update
  if [ ! -z "${CHOICE}" ] && [ "${CHOICE}" != "01" ]
  then
    READ_MENU_COMMAND ${MENU_NAME} ${CHOICE} 
  else
    exit 1
  fi
done