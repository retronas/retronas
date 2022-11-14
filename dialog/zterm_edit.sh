#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=zterm-edit
cd ${DIDIR}

[ ! -f /opt/zterm/zconfig ] && echo "Install zterm first" && PAUSE

# DEFAULTS
DEVICE="$(awk -F "=" '/^DEV/{print $2}' /opt/zterm/zconfig)"
SPEED="$(awk -F "=" '/^SPEED/{print $2}' /opt/zterm/zconfig)"
ADDN="$(awk -F "=" '/^ADDN/{print $2}' /opt/zterm/zconfig)"
OUTDIR=/opt/zterm

source $_CONFIG
cd ${DIDIR}

rn_zterm_edit() {
  READ_MENU_TDESC "${MENU_NAME}"

  MENU_ARRAY=(
    "Device:"      1 5 "$DEVICE"  1 20 20 20
    "Speed:"       2 5 "$SPEED"   2 20 20 20
    "Additional"   3 5 "$ADDN"    3 20 20 20
  )

  DLG_FORM "${MENU_TNAME}" "${MENU_ARRAY}" 8 "${MENU_BLURB}"

  [ ! -z ${CHOICE[@]} ] && rn_zterm_write_config

}

rn_zterm_write_config() {

  if [ ! -z ${CHOICE[0]} ] 
  then
    echo "Updating device to ${DEVSTR}${CHOICE[0]}"
    sed -i -r "s#^DEV.+#DEV=${DEVSTR}${CHOICE[0]}#" $OUTDIR/zconfig
    sed -i -r "s#^SPEED.+#SPEED=${DEVSTR}${CHOICE[1]}#" $OUTDIR/zconfig
    sed -i -r "s#^ADDN.*#ADDN=${DEVSTR}${CHOICE[2]}#" $OUTDIR/zconfig
    sed -i -r "s#^Condition.+#ConditionPathExists=${DEVSTR}${CHOICE[0]}#" /usr/lib/systemd/system/zterm.service
    sudo systemctl daemon-reload
    sudo systemctl restart zterm.service
  else
    echo "No change" 
    PAUSE
  fi
  EXIT_OK
}

DROP_ROOT
rn_zterm_edit