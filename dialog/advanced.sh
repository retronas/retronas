#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}
CHOICE=""

rn_advanced() {

  READ_MENU_JSON "advanced"
  local MENU_BLURB="\nPlease select an tool to install" 
  DLG_MENUJ "Advanced Menu" 10 "${MENU_BLURB}"

}

DROP_ROOT
CLEAR
while true
do
  rn_advanced
  case ${CHOICE} in
  01)
    exit 0
    ;;
  02)
    # hdparm
    EXEC_SCRIPT tool_hdparm.sh
    ;;
  03)
    # hdparm
    EXEC_SCRIPT tcpser.sh
    ;;
  04)
    # laptopo lid
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_disable-laptop-lid.yml
    PAUSE
    ;;
  *)
    exit 1
    ;;
  esac
done
