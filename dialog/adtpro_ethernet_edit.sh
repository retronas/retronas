#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=adtpro_ethernet_edit
cd ${DIDIR}

OUTDIR=/opt/adtpro
SERVICE_CONFIG=${OUTDIR}/ADTPro.properties

[ ! -f ${SERVICE_CONFIG} ] && echo "Install adtpro first" && PAUSE

# DEFAULTS
PORT="$(awk -F "=" '/^SerialIPPort/{print $2}' ${SERVICE_CONFIG})"

source $_CONFIG
cd ${DIDIR}

rn_adtpro_ethernet_edit() {
  READ_MENU_TDESC "${MENU_NAME}"

  MENU_ARRAY=(
    "Listen Port:"            1 5 "$PORT"     1 20 20 20
  )

  DLG_FORM "${MENU_TNAME}" "${MENU_ARRAY}" 8 "${MENU_BLURB}"

  [ ${#CHOICE[@]}  -gt 0 ] && rn_adtpro_write_config

}

rn_adtpro_write_config() {

  CLEAR
  if [ ! -z ${CHOICE[0]} ] 
  then
    echo "Updating device to ${DEVSTR}${CHOICE[0]}"
    sed -i -r "s#^SerialIPPort.+#SerialIPPort=${DEVSTR}${CHOICE[0]}#" $SERVICE_CONFIG

    #sed -i -r "s#^Condition.+#ConditionPathExists=${DEVSTR}${CHOICE[0]}#" /usr/lib/systemd/system/adtpro.service
    sudo systemctl daemon-reload

    echo "Config file updated, now you can (re)start the service from the Ethernet menu"
    PAUSE
  else
    echo "No change" 
    PAUSE
  fi
  EXIT_OK
}

DROP_ROOT
rn_adtpro_ethernet_edit