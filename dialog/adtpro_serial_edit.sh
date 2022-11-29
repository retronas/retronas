#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=adtpro_serial_edit
cd ${DIDIR}

OUTDIR=/opt/adtpro
SERVICE_CONFIG=${OUTDIR}/ADTPro.properties

[ ! -f ${SERVICE_CONFIG} ] && echo "Install adtpro first" && PAUSE

# DEFAULTS
DEVICE="$(awk -F "=" '/^CommPort\=.+$/{print $2}' ${SERVICE_CONFIG})"
SPEED="$(awk -F "=" '/^CommPortSpeed/{print $2}' ${SERVICE_CONFIG})"
BSPEED="$(awk -F "=" '/^CommPortBootstrapSpeed/{print $2}' ${SERVICE_CONFIG})"
BPACING="$(awk -F "=" '/^CommPortBootstrapPacing/{print $2}' ${SERVICE_CONFIG})"
HANDSHAKE="$(awk -F "=" '/^HardwareHandshaking/{print $2}' ${SERVICE_CONFIG})"


source $_CONFIG
cd ${DIDIR}

rn_adtpro_serial_edit() {
  READ_MENU_TDESC "${MENU_NAME}"

  MENU_ARRAY=(
    "Comm Port Device:"       1 5 "$DEVICE"     1 27 20 20
    "Comm Port Speed:"        2 5 "$SPEED"      2 27 20 20
    "Bootstrap Speed:"        3 5 "$BSPEED"     3 27 20 20
    "Bootstrap Pacing:"       4 5 "$BPACING"    4 27 20 20
    "Hardware Handshaking:"   5 5 "$HANDSHAKE"  5 27 20 20
  )

  DLG_FORM "${MENU_TNAME}" "${MENU_ARRAY}" 8 "${MENU_BLURB}"

  [ ${#CHOICE[@]}  -gt 1 ] && rn_adtpro_write_config

}

rn_adtpro_write_config() {

  CLEAR
  if [ ! -z ${CHOICE[0]} ] 
  then
    echo "Updating device to ${DEVSTR}${CHOICE[0]}"
    sed -i -r "s#^CommPort\=.+#CommPort=${DEVSTR}${CHOICE[0]}#" ${SERVICE_CONFIG}
    sed -i -r "s#^CommPortSpeed.+#CommPortSpeed=${DEVSTR}${CHOICE[1]}#" ${SERVICE_CONFIG}
    sed -i -r "s#^CommPortBootstrapSpeed.*#CommPortBootstrapSpeed=${DEVSTR}${CHOICE[2]}#" ${SERVICE_CONFIG}
    sed -i -r "s#^CommPortBootstrapPacing.*#CommPortBootstrapPacing=${DEVSTR}${CHOICE[3]}#" ${SERVICE_CONFIG}
    sed -i -r "s#^HardwareHandshaking.*#HardwareHandshaking=${DEVSTR}${CHOICE[4]}#" ${SERVICE_CONFIG}

    #sed -i -r "s#^Condition.+#ConditionPathExists=${DEVSTR}${CHOICE[0]}#" /usr/lib/systemd/system/adtpro.service
    sudo systemctl daemon-reload

    echo "Config file updated, now you can (re)start the service from the Serial menu"
    PAUSE
  else
    echo "No change" 
    PAUSE
  fi
  EXIT_OK
}

DROP_ROOT
rn_adtpro_serial_edit