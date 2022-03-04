#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
SERVICE="hdparm"
UNITTYPE="timer"
MENU_NAME=ondevice

cd ${DIDIR}

rn_odman() {
  source $_CONFIG
  READ_MENU_JSON "ondevice"
  local MENU_BLURB="\nChoose an item to install"
  DLG_MENUJ "On-Device Management Menu" 10 "${MENU_BLURB}"
}

DROP_ROOT
CLEAR

while true
do
  rn_odman
  if [ ! -z "${CHOICE}" ]
  then
    READ_MENU_COMMAND ${MENU_NAME} ${CHOICE} 
  else
    exit 1
  fi
done
