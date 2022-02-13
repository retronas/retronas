#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
SERVICE="hdparm"
UNITTYPE="timer"

cd ${DIDIR}

rn_hdparm() {
  source $_CONFIG

  local MENU_ARRAY=(
    01 "Main Menu"
    02 "uCON64"
  )

  local MENU_BLURB="\nChoose an item to install"

  DLG_MENU "On-Device Management Menu" $MENU_ARRAY 10 "${MENU_BLURB}"

}

DROP_ROOT
CLEAR

while true
do
  rn_hdparm
  case ${CHOICE} in
    01)
      EXEC_SCRIPT retronas_main.sh
      ;;
    02)
      # uCON64
      CLEAR
      RN_INSTALL_EXECUTE install_ucon64.yml 
      PAUSE
      ;;
    *)
      exit 1
      ;;
  esac
done
