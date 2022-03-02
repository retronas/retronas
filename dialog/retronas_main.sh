#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=main
cd ${DIDIR}

rn_main() {

  READ_MENU_JSON "${MENU_NAME}"

  local MENU_BLURB="\
  \nPlease select an option. \
  \n\nPlease ensure that you have configured your RetroNAS user and top level directory in the \"Global configration\" section before installing any tools. \
  \n\nCurrent RetroNAS user: \"${OLDRNUSER}\" \
  \nCurrent RetroNAS top level directory: \"${OLDRNPATH}\" \
  \n\nChanging either of these options will require tools to be reinstalled."

  DLG_MENUJ "Main Menu" 3 "${MENU_BLURB}"

}

while true
do
  rn_main
  if [ ! -z "${CHOICE}" ] && [ "${CHOICE}" != "01" ]
  then
    READ_MENU_COMMAND ${MENU_NAME} ${CHOICE} 
  else
    exit 1
  fi
done
