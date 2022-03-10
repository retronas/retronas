#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=tcpser
cd ${DIDIR}

CLEAR
rn_tcpser() {
  source $_CONFIG
  READ_MENU_JSON "${MENU_NAME}"
  READ_MENU_TDESC "${MENU_NAME}"
  DLG_MENUJ "${MENU_TNAME}" 10 "${MENU_BLURB}"
  
  if [ ! -z "${CHOICE}" ]
  then
    READ_MENU_COMMAND ${MENU_NAME} ${CHOICE}
    EXIT_OK
  else
    EXIT_CANCEL
  fi
}


DROP_ROOT
CLEAR
rn_tcpser
