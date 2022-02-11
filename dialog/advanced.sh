#!/bin/bash

_CONFIG=/opt/retronas/dialog/retronas.cfg
source $_CONFIG
source ${DIDIR}/common.sh

cd ${DIDIR}

rn_advanced() {
source $_CONFIG
dialog \
  --backtitle "RetroNAS" \
  --title "RetroNAS Advanced Tools menu" \
  --clear \
  --menu "My IP addresses: ${MY_IPS} \
  \n
  \nPlease select an tool to install" ${MG} 10 \
  "01" "Main Menu" \
  "02" "hdparm - manage hdd standy mode etc" \
  2> ${TDIR}/rn_advanced
}

DROP_ROOT
CLEAR
while true
do
  rn_advanced
  CHOICE=$( cat ${TDIR}/rn_advanced )
  case ${CHOICE} in
  01)
    EXEC_SCRIPT retronas_main.sh
    ;;
  02)
    # gogrepo
    EXEC_SCRIPT tool_hdparm.sh
    ;;
  *)
    exit 1
    ;;
  esac
done
