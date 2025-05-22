#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=tcpser-service

cd ${DIDIR}

rn_tcpser_status() {
  source $_CONFIG

  local MODE="${1}"
  READ_MENU_TDESC "${MENU_NAME}"

  MENU_ARRAY=(
    "Listen Port:" 1 5 "$LISTEN"  2 20 20 20
  )

  DLG_FORM "${MENU_TNAME}" "${MENU_ARRAY}" 8 "${MENU_BLURB}"

  [ ${#CHOICE[@]} -gt 0 ] && RN_SYSTEMD_$(echo ${MODE} | tr '[a-z]' '[A-Z]') tcpser@${CHOICE}.service

}


CLEAR
rn_tcpser_status "${1}"
