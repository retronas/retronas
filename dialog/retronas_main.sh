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
      EXEC_SCRIPT configure.sh
      ;;
    03)
      EXEC_SCRIPT install.sh
      ;;
    04)
      EXEC_SCRIPT services.sh
      ;;
    05)
      EXEC_SCRIPT tools.sh
      ;;
    06)
      EXEC_SCRIPT odman.sh
      ;;
    07)
      EXEC_SCRIPT advanced.sh
      ;;
    50)
      EXEC_SCRIPT experimental.sh
      ;;
    *)
      clear
      exit
  esac
done
