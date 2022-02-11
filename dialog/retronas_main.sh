#!/bin/bash

_CONFIG=/opt/retronas/dialog/retronas.cfg
source $_CONFIG
source ${DIDIR}/common.sh
cd ${DIDIR}

rn_main() {

  local MENU_ARRAY=(
    1 "Exit RetroNAS"
    2 "Global configuration"
    3 "Install things"
    4 "Check services"
    5 "Run tools and scripts"
    6 "Advanced"
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
    2)
      bash configure.sh
      ;;
    3)
      bash install.sh
      ;;
    4)
      bash services.sh
      ;;
    5)
      bash tools.sh
      ;;
    *)
      #clear
      exit 0
  esac
done
