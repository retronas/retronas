#!/bin/bash

clear
_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}

rn_tools() {
  source $_CONFIG

  local MENU_ARRAY=(
    01 "Back"
    02 "GOG - Download your GOG installers and extras"
    03 "Nintendo 3DS QR code generator for FBI homebrew"
    05 "ROM import tool via Smokemonster SMDBs"
  )

  local MENU_BLURB="Please select an option to install"

  DLG_MENU "Tools Menu" $MENU_ARRAY 10 "${MENU_BLURB}"

}

DROP_ROOT
while true
do
  rn_tools
  case ${CHOICE} in
  01)
    clear
    exit 0
    ;;
  02)
    # gogrepo
    bash gogrepo.sh
    ;;
  03)
    # 3DS QR
    clear
    ${SUCOMMAND} ../scripts/3ds_qr.sh
    PAUSE
    ;;
  05)
    # ROM import SMDB
    CLEAR
    bash romimport.sh
    ;;
  *)
    exit 1
    ;;
  esac
done
