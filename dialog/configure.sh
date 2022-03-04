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
  READ_MENU_TDESC "${MENU_NAME}"
  DLG_MENUJ "${MENU_TNAME}" 4 "${MENU_BLURB}"

}

while true
do
  rn_config
  if [ ! -z "${CHOICE}" ]
  then
    READ_MENU_COMMAND ${MENU_NAME} ${CHOICE} 
  else
    EXIT_CANCEL
  fi
done