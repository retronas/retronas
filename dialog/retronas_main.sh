#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}

rn_main() {

  local MENU_ARRAY=(
    01 "Exit RetroNAS"
    02 "Global configuration"
    03 "Install things"
    04 "Check services"
    05 "Run tools and scripts"
    06 "On-Device Management Tools"
    07 "Advanced"
  )

  local MENU_BLURB="\
  \nPlease select an option. \
  \n\nPlease ensure that you have configured your RetroNAS user and top level directory in the \"Global configration\" section before installing any tools. \
  \n\nCurrent RetroNAS user: \"${OLDRNUSER}\" \
  \nCurrent RetroNAS top level directory: \"${OLDRNPATH}\" \
  \n\nChanging either of these options will require tools to be reinstalled."

  DLG_MENU "Main Menu" $MENU_ARRAY 3 "${MENU_BLURB}"

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
    *)
      clear
      exit
  esac
done
