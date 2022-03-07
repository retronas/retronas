#!/bin/bash

clear
_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=$1
cd ${DIDIR}

DROP_ROOT
CLEAR

rn_dialog_yn() {
  source $_CONFIG

  READ_MENU_JSON "${MENU_NAME}"
  READ_MENU_TDESC "${MENU_NAME}"
  DLG_YN "${MENU_TNAME}" "${MENU_BLURB}"

  if [ ! -z "${CHOICE}" ]
  then
    READ_MENU_COMMAND ${MENU_NAME} ${CHOICE} 
  else
    EXIT_CANCEL
  fi

}

rn_dialog_yn ${MENU_NAME}