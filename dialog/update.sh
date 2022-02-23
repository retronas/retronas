#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}
CHOICE=""

rn_update() {

  READ_MENU_JSON "update"
  local MENU_BLURB="\nPlease select a tool to update" 
  DLG_MENUJ "Update Menu" 10 "${MENU_BLURB}"

}

DROP_ROOT
CLEAR
while true
do
  rn_update
  case ${CHOICE} in
  01)
    exit 0
    ;;
  02)
    # update RetroNAS
    CLEAR
    EXEC_SCRIPT ../scripts/static/update-retronas.sh
    EXEC_SCRIPT retronas.main.sh
    ;;
  03)
    # update ROM DIRS
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_romdir.yml
    PAUSE
    ;;
  *)
    exit 1
    ;;
  esac
done
