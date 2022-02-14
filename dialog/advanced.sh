#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

cd ${DIDIR}

rn_advanced() {
  
  local MENU_ARRAY=(
    01 "Main Menu"
    02 "hdparm - manage hdd standy mode etc"
    99 "webui - experimental retronas webui (cockpit)"
  )

  local MENU_BLURB="\nPlease select an tool to install"

  DLG_MENU "Advanced Menu" $MENU_ARRAY 10 "${MENU_BLURB}"

}

DROP_ROOT
CLEAR
while true
do
  rn_advanced
  case ${CHOICE} in
  01)
    EXEC_SCRIPT retronas_main.sh
    ;;
  02)
    # hdparm
    EXEC_SCRIPT tool_hdparm.sh
    ;;
  99)
    # experimental webui
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_cockpit-retronas.yml
    PAUSE
    ;;
  *)
    exit 1
    ;;
  esac
done
