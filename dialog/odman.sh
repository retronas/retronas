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
    02 "uCON64 - Multipurpose Swiss Army Knife Backup/Copier tool"
    03 "extract-xiso - XISO Tool"
    04 "hdl-dump - PS2 HDD Game management"
    05 "NBD client - Network Block Device Client"
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
    *)
      exit 1
      ;;
  esac
done
