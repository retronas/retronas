#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=dexdrive_serial_edit
cd ${DIDIR}

[ ! -f ${SERVICE_CONFIG} ] && echo "Install adtpro first" && PAUSE

# DEFAULTS
DEVICE="/dev/ttyS0"

source $_CONFIG
cd ${DIDIR}

rn_dexdrive_serial_edit() {
  READ_MENU_TDESC "${MENU_NAME}"

  MENU_ARRAY=(
    "Serial Device:"       1 5 "$DEVICE"     1 27 20 20
  )

  DLG_FORM "${MENU_TNAME}" "${MENU_ARRAY}" 8 "${MENU_BLURB}"

  [ ${#CHOICE[@]}  -gt 0 ] && export DEXDRIVE=$(echo $DEVICE | sed 's#^/dev/##')
  EXIT_OK

}


DROP_ROOT
rn_dexdrive_serial_edit