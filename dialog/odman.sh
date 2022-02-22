#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
SERVICE="hdparm"
UNITTYPE="timer"

cd ${DIDIR}

rn_hdparm() {
  source $_CONFIG

  READ_MENU_JSON "ondevice"
  local MENU_BLURB="\nChoose an item to install"
  DLG_MENUJ "On-Device Management Menu" 10 "${MENU_BLURB}"

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
      # extract-xiso
      CLEAR
      RN_INSTALL_EXECUTE install_extract-xiso.yml 
      PAUSE
      ;;
    04)
      # hdl-dump
      CLEAR
      RN_INSTALL_EXECUTE install_hdldump.yml 
      PAUSE
      ;;
    05)
      # hdl-dump
      CLEAR
      RN_INSTALL_EXECUTE install_nbd-client.yml 
      PAUSE
      ;;
    06)
      # psfshell
      CLEAR
      RN_INSTALL_EXECUTE install_pfsshell.yml 
      PAUSE
      ;;
    *)
      exit 1
      ;;
  esac
done
