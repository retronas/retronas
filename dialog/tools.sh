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
  "02" "gogrepo - configure GOG account" \
  "03" "gogrepo - download Windows games" \
  "04" "gogrepo - download Linux games" \
  "05" "gogrepo - download Mac games" \
  "06" "gogrepo - download ALL games" \
  "10" "Nintendo 3DS QR code generate" \
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
    # gogrepo login
    ${RNDIR}/scripts/gogrepo_login.sh
    echo "${PAUSEMSG}"
    read -s
    ;;
  03)
    # gogrepo download windows
    ${RNDIR}/scripts/gogrepo_download.sh windows
    echo "${PAUSEMSG}"
    read -s
    ;;
  04)
    # gogrepo download mac
    ${RNDIR}/scripts/gogrepo_download.sh mac
    echo "${PAUSEMSG}"
    read -s
    ;;
  05)
    # gogrepo download linux
    ${RNDIR}/scripts/gogrepo_download.sh linux
    echo "${PAUSEMSG}"
    read -s
    ;;
  06)
    # gogrepo download all
    ${RNDIR}/scripts/gogrepo_download.sh all
    echo "${PAUSEMSG}"
    read -s
    ;;
  10)
    # 3DS QR
    echo "3DS QR TBA"
    echo "${PAUSEMSG}"
    read -s
    ;;
  *)
    exit 1
    ;;
  esac
done
