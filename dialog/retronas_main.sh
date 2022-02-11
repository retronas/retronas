#!/bin/bash

clear
source /opt/retronas/dialog/retronas.cfg
cd ${DIDIR}

rn_main() {
source /opt/retronas/dialog/retronas.cfg
dialog \
  --backtitle "RetroNAS" \
  --title "RetroNAS Main Menu" \
  --clear \
  --menu "My IP addresses: ${MY_IPS} \
  \n
  \nPlease select an option. \
  \n
  \nPlease ensure that you have configured your RetroNAS user and top level directory in the \"Global configration\" section before installing any tools. \
  \n
  \nCurrent RetroNAS user: \"${OLDRNUSER}\" \
  \nCurrent RetroNAS top level directory: \"${OLDRNPATH}\" \
  \n
  \nChanging either of these options will require tools to be reinstalled." ${MG} 3 \
  "1" "Exit RetroNAS" \
  "2" "Global configuration" \
  "3" "Install things" \
  "4" "Check services" \
  "5" "Run tools and scripts" \
  "6" "Advanced Tools" \
  2>${TDIR}/rn_main
}

while true
do
  rn_main
  CHOICE=$(cat ${TDIR}/rn_main)
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
    6)
      bash advanced.sh
      ;;
    *)
      clear
      exit 0
  esac
done
