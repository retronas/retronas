#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=experimental
cd ${DIDIR}
CHOICE=""

rn_advanced() {
  READ_MENU_JSON "${MENU_NAME}"
  local MENU_BLURB="\nWARNING these tools are very EXPERIMENTAL and could break your system or destroy your data! Do not use these unless you are comfortable with losing everthing"
  DLG_MENUJ "EXPERIMENTAL Menu" 10 "${MENU_BLURB}"

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
    EXIT_CANCEL
  fi
done