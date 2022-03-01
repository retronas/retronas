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
  local MENU_BLURB="\nPlease select an option to install"
  DLG_MENUJ "Main Menu" 10 "${MENU_BLURB}"
}

while true
do
  rn_install_chooser
  if [ ! -z "${CHOICE}" ] && [ "${CHOICE}" != "01" ]
  then
    READ_MENU_COMMAND ${MENU_NAME} ${CHOICE} 
  else
    exit 1
  fi
done
