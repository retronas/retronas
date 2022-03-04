#!/bin/bash

clear
_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=install
cd ${DIDIR}

rn_install_chooser() {
  source $_CONFIG
  READ_MENU_JSON "${MENU_NAME}"
  READ_MENU_TDESC "${MENU_NAME}"
  DLG_MENUJ "${MENU_TNAME}" 10 "${MENU_BLURB}"
}

while true
do
  rn_install_chooser
  if [ ! -z "${CHOICE}" ]
  then
    READ_MENU_COMMAND ${MENU_NAME} ${CHOICE} 
  else
    EXIT_CANCEL
  fi
done
