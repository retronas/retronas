#!/bin/bash

clear
source /opt/retronas/dialog/retronas.cfg
cd ${DIDIR}

rn_retronas_password() {
source /opt/retronas/dialog/retronas.cfg
dialog \
  --backtitle "RetroNAS" \
  --title "RetroNAS Password Configuration" \
  --clear \
  --defaultno \
  --yesno \
  "Configure the RetroNAS password. \
  \n
  \nThe current RetroNAS user is \"${OLDRNUSER}\" \
  \n
  \nIf you are having problems with CIFS/SMB shares, you can reset their password here.
  \n
  \nProceed?" ${MG}
}

rn_retronas_password
CHOICE="$?"

case ${CHOICE} in
  0)
    # Yes, change the password
    clear
    echo ; echo
    echo "Changing the Samba/SMB/CIFS password for user ${OLDRNUSER} :"
    echo
    smbpasswd -a ${OLDRNUSER}
    echo
    echo "${PAUSEMSG}"
    read -s
    exit 0
    ;;
  *)
    # No, exit
    exit ${CHOICE}
    ;;
esac
