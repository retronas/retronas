#!/bin/bash

clear
_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=config
cd ${DIDIR}

rn_config() {
  source $_CONFIG

  READ_MENU_JSON "${MENU_NAME}"

  local MENU_BLURB="\nPlease select a configuration\
  \n
  \nCurrent RetroNAS user: \"${OLDRNUSER}\" \
  \nCurrent RetroNAS top level directory: \"${OLDRNPATH}\""

  DLG_MENUJ "Configuration Menu" 4 "${MENU_BLURB}"

}

while true
do
  rn_config
  if [ ! -z "${CHOICE}" ] && [ "${CHOICE}" != "01" ]
  then
    READ_MENU_COMMAND ${MENU_NAME} ${CHOICE} 
  else
    exit 1
  fi
done