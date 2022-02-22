#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}

rn_main() {

  READ_MENU_JSON "main"

  local MENU_BLURB="\
  \nPlease select an option. \
  \n\nPlease ensure that you have configured your RetroNAS user and top level directory in the \"Global configration\" section before installing any tools. \
  \n\nCurrent RetroNAS user: \"${OLDRNUSER}\" \
  \nCurrent RetroNAS top level directory: \"${OLDRNPATH}\" \
  \n\nChanging either of these options will require tools to be reinstalled."

  DLG_MENUJ "Main Menu" 3 "${MENU_BLURB}"

}


#clear
while true
do
  rn_main
  case ${CHOICE} in
    01)
      clear
      exit 0
      ;;
    02)
      bash configure.sh
      ;;
    03)
      bash install.sh
      ;;
    04)
      bash services.sh
      ;;
    05)
      bash tools.sh
      ;;
    06)
      bash odman.sh
      ;;
    07)
      bash advanced.sh
      ;;
    50)
      bash experimental.sh
      ;;
    *)
      clear
      exit
  esac
done
