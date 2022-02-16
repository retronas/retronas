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
    01 "Back"
    02 "uCON64"
    03 "extract-xiso"
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
      clear
      exit 0
      ;;
    02)
      # uCON64
      CLEAR
      RN_INSTALL_EXECUTE install_ucon64.yml 
      PAUSE
      ;;
    03)
      # uCON64
      CLEAR
      RN_INSTALL_EXECUTE install_extract-xiso.yml 
      PAUSE
      ;;
    *)
      exit 1
      ;;
  esac
done
