#!/bin/bash

clear
_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}

rn_config() {
  source $_CONFIG

  READ_MENU_JSON "config"

  local MENU_BLURB="\nPlease select a configuration\
  \n
  \nCurrent RetroNAS user: \"${OLDRNUSER}\" \
  \nCurrent RetroNAS top level directory: \"${OLDRNPATH}\""

  DLG_MENUJ "Configuration Menu" 4 "${MENU_BLURB}"

}

while true
do
  rn_config
  case ${CHOICE} in
    01)
      clear
      exit 0
      ;;
    02)
      EXEC_SCRIPT retronas_user.sh
      ;;
    03)
      EXEC_SCRIPT retronas_password.sh
      ;;
    04)
      EXEC_SCRIPT retronas_path.sh
      ;;
    05)
      EXEC_SCRIPT retronas_fixperms.sh
      ;;
    06)
      EXEC_SCRIPT retronas_etherdfs_interface.sh
      ;;
    *)
      clear
      exit 1
  esac
done
