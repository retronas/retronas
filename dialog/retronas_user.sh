#!/bin/bash

clear
_CONFIG=/opt/retronas/dialog/retronas.cfg
source $_CONFIG
cd ${DIDIR}

rn_retronas_user() {
source $_CONFIG
dialog \
  --backtitle "RetroNAS" \
  --title "RetroNAS User Configuration" \
  --clear \
  --inputbox \
  "Please enter the username for all RetroNAS services to run as. \
  \n
  \nThis is currently \"${OLDRNUSER}\" \
  \n
  \nThis will normally default to \"pi\" on a default Rasberry Pi OS install. \
  \n
  \nIt is recommended you leave it as default unless you know what you are doing." ${MG} ${OLDRNUSER} 2>${TDIR}/rn_retronas_user
}

rn_retronas_user_confirm() {
NEWRNUSER=$( cat ${TDIR}/rn_retronas_user )
dialog \
  --clear \
  --title "Confirm" \
  --defaultno \
  --yesno "Do you want to save this setting? \
  \nNewRetroNAS user: \"${NEWRNUSER}\" " ${MG}
}

# Choose the user
rn_retronas_user

# Confirm the input
rn_retronas_user_confirm
CHOICE="$?"

case ${CHOICE} in
  0)
    source $_CONFIG
    # Yes, change the value
    # Delete the old value
    sed -i '/retronas_user:/d' "${ANCFG}"
    # Add the new value and re-source
    echo "retronas_user: \"${NEWRNUSER}\"" >> "${ANCFG}"
    exit 0
    ;;
  *)
    # No, exit
    exit ${CHOICE}
    ;;
esac
