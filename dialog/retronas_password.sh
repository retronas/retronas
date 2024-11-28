#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=update-password
cd ${DIDIR}

rn_retronas_password() {
  source ${LIBDIR}/common.sh

  READ_MENU_TDESC "${MENU_NAME}"

  MENU_ARRAY=(
    "Password:" 1 10 ""  1 20 20 20
    "Repeat:"   2 10 ""  2 20 20 20
  )

  DLG_PASSWORD "${MENU_TNAME}" "${MENU_ARRAY}" 5 "${MENU_BLURB}"

  # if we can't create the sub-window report it and exit
  echo ${CHOICE[0]} | grep "make sub-window" &> /dev/null
  if [ $? -eq 0 ]
  then
    echo "Failed to create sub-window, if possible resize your terminal window and try again"
    PAUSE
    exit
  fi

  PASS_ONE=${CHOICE[0]}
  PASS_TWO=${CHOICE[1]}

  if [ ! -z "${PASS_ONE}" ]
  then
    if [ "${PASS_ONE}" == "${PASS_TWO}" ]
    then
      CLEAR
      /opt/retronas/scripts/static/update-passwd.sh "${PASS_ONE}"
      PAUSE
    else
      RN_LOG "Passwords do not match"
      PAUSE
      rn_retronas_password
    fi
  else
    RN_LOG "Password was blank"
    EXIT_CANCEL
  fi

}

CLEAR
rn_retronas_password

