#!/bin/bash

clear
_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=tools
cd ${DIDIR}

rn_tools() {
  source $_CONFIG

  READ_MENU_JSON "${MENU_NAME}"
  READ_MENU_TDESC "${MENU_NAME}"
  DLG_MENUJ "${MENU_TNAME}" 10 "${MENU_BLURB}"

}

DROP_ROOT
while true
do
  rn_tools
  case ${CHOICE} in
  01)
    EXIT_OK
    ;;
  02)
    # gogrepo
    EXEC_SCRIPT "d-gogrepo"
    ;;
  03)
    # 3DS QR
    clear
    ${SUCOMMAND} ../scripts/3ds_qr.sh
    PAUSE
    ;;
  04)
    # ROM import SMDB
    CLEAR
    EXEC_SCRIPT "d-romimport"
    ;;
  *)
    EXIT_CANCEL
    ;;
  esac
done
