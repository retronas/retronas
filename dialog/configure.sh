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
  "01" "Back" \
  "02" "Configure RetroNAS user" \
  "03" "Configure RetroNAS password" \
  "04" "Configure RetroNAS top level directory" \
  "05" "Fix on-disk permissions" \
  "06" "Set EtherDFS network interface" \
  2> ${TDIR}/rn_config
}

while true
do
  rn_config
  CHOICE=$(cat ${TDIR}/rn_config)
  case ${CHOICE} in
    02)
      bash retronas_user.sh
      ;;
    03)
      bash retronas_password.sh
      ;;
    04)
      bash retronas_path.sh
      ;;
    05)
      bash retronas_fixperms.sh
      ;;
    06))
      bash retronas_etherdfs_interface.sh
      ;;
    *)
      clear
      exit 0
  esac
done
