#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=update-wifi-password
cd ${DIDIR}

rn_wifi_password() {
  source ${LIBDIR}/common.sh

  READ_MENU_TDESC "${MENU_NAME}"

  MENU_ARRAY=(
    "Password:" 1 10 ""  1 20 20 20
    "Repeat:"   2 10 ""  2 20 20 20
  )

  DLG_PASSWORD "${MENU_TNAME}" "${MENU_ARRAY}" 10 "${MENU_BLURB}"

  PASS_ONE=${CHOICE[0]}
  PASS_TWO=${CHOICE[1]}

  if [ ! -z "${PASS_ONE}" ]
  then
    if [ "${PASS_ONE}" == "${PASS_TWO}" ]
    then
      CLEAR
      /opt/retronas/scripts/static/wifi-update-passwd.sh "${PASS_ONE}"
      PAUSE
    else
      RN_LOG "Passwords do not match"
      PAUSE
      rn_wifi_password
    fi
  else
    RN_LOG "Password was blank"
    EXIT_CANCEL
  fi

}

CLEAR
rn_wifi_password

