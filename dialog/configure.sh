#!/bin/bash

clear
source /opt/retronas/dialog/retronas.cfg
cd ${DIDIR}

rn_config() {
source /opt/retronas/dialog/retronas.cfg
dialog \
  --backtitle "RetroNAS" \
  --title "RetroNAS Configuration Menu" \
  --clear \
  --menu "My IP addresses: ${MY_IPS}
  \n
  \nPlease select a configuration\
  \n
  \nCurrent RetroNAS user: \"${OLDRNUSER}\" \
  \nCurrent RetroNAS top level directory: \"${OLDRNPATH}\" " ${MG} 4 \
  "1" "Back" \
  "2" "Configure RetroNAS user" \
  "3" "Configure RetroNAS password" \
  "4" "Configure RetroNAS top level directory" \
  "5" "Fix on-disk permissions" \
  2> ${TDIR}/rn_config
}

while true
do
  rn_config
  CHOICE=$(cat ${TDIR}/rn_config)
  case ${CHOICE} in
    2)
      bash retronas_user.sh
      ;;
    3)
      bash retronas_password.sh
      ;;
    4)
      bash retronas_path.sh
      ;;
    5)
      bash retronas_fixperms.sh
      ;;
    *)
      clear
      exit 0
  esac
done
