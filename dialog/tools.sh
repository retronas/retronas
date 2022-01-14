#!/bin/bash

clear
source /opt/retronas/dialog/retronas.cfg
cd ${DIDIR}

rn_tools() {
source /opt/retronas/dialog/retronas.cfg
dialog \
  --backtitle "RetroNAS" \
  --title "RetroNAS Tools menu" \
  --clear \
  --menu "My IP addresses: ${MY_IPS} \
  \n
  \nPlease select an service to check" ${MG} 10 \
  "01" "Main Menu" \
  "02" "Nintendo 3DS QR code generate" \
  "03" "GOG Sync" \
  2> ${TDIR}/rn_tools
}

SC="systemctl --no-pager --full"

while true
do
  rn_tools
  CHOICE=$( cat ${TDIR}/rn_tools )
  PAUSEMSG='Press [Enter] to continue...'
  case ${CHOICE} in
  02)
    # 3DS QR
    echo "${PAUSEMSG}"
    read -s
    ;;
  03)
    # GOG
    echo "${PAUSEMSG}"
    read -s
    ;;
  *)
    exit 1
    ;;
  esac
done
