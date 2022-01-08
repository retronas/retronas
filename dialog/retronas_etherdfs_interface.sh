#!/bin/bash

clear
source /opt/retronas/dialog/retronas.cfg
cd ${DIDIR}

rn_etherdfs_if() {
source /opt/retronas/dialog/retronas.cfg
dialog \
  --backtitle "RetroNAS" \
  --title "RetroNAS EtherDFS Interface" \
  --clear \
  --inputbox \
  "Please enter the interface name for EtherDFS to bind to. \
  \n
  \nThis is currently \"${OLDETHERDFSIF}\" \
  \n
  \nNormally this is something like eth0 for wired Ethernet. \
  \n
  \nIf EtherDFS is installed, you will need to re-run the installer to apply the change." \
  ${MG} ${OLDETHERDFSIF} 2>${TDIR}/rn_etherdfs_if
}

rn_etherdfs_if_confirm() {
NEWETHERDFSIF=$( cat ${TDIR}/rn_etherdfs_if )
dialog \
  --clear \
  --title "Confirm" \
  --defaultno \
  --yesno "Do you want to save this setting? \
  \nNew EtherDFS interface: \"${NEWETHERDFSIF}\" " ${MG}
}

# Choose the user
rn_etherdfs_if

# Confirm the input
rn_etherdfs_if_confirm
CHOICE="$?"

case ${CHOICE} in
  0)
    # Yes, change the value
    # Delete the old value
    sed -i '/retronas_etherdfs_interface:/d' "${ANCFG}"
    # Add the new value and re-source
    echo "retronas_etherdfs_interface: \"${NEWETHERDFSIF}\"" >> "${ANCFG}"
    source /opt/retronas/dialog/retronas.cfg
    exit 0
    ;;
  *)
    # No, exit
    exit ${CHOICE}
    ;;
esac
