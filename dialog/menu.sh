#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=$1
cd ${DIDIR}
CHOICE=""

rn_menu() {

  READ_MENU_JSON "${MENU_NAME}"
  READ_MENU_TDESC "${MENU_NAME}"
  DLG_MENUJ "${MENU_TNAME}" 10 "${MENU_BLURB}"

}

DROP_ROOT
CLEAR

while true
do
  rn_menu
  if [ ! -z "${CHOICE}" ]
  then
    READ_MENU_COMMAND ${MENU_NAME} ${CHOICE} 
  else
    EXIT_CANCEL
  fi
done
