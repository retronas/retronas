#!/bin/bash

clear
source /opt/retronas/dialog/retronas.cfg
cd ${DIDIR}

rn_tools() {
source /opt/retronas/dialog/retronas.cfg
dialog \
  --backtitle "RetroNAS" \
  --title "RetroNAS Tools menu" \
  --clear \
  --menu "My IP addresses: ${MY_IPS} \
  \n
  \nPlease select an service to check" ${MG} 10 \
  "01" "Main Menu" \
  "02" "GOG - Download your GOG installers and extras" \
  "03" "Nintendo 3DS QR code generator for FBI homebrew" \
  "05" "ROM import tool via Smokemonster SMDBs" \
  2> ${TDIR}/rn_tools
}

## If this is run as root, switch to our RetroNAS user
## Manifests and cookies stored in ~/.gogrepo
if [ "${USER}" == "root" ]
then
  SUCOMMAND="sudo -u ${OLDRNUSER}"
else
  SUCOMMAND=""
fi

SC="systemctl --no-pager --full"

while true
do
  rn_tools
  CHOICE=$( cat ${TDIR}/rn_tools )
  PAUSEMSG='Press [Enter] to continue...'
  case ${CHOICE} in
  02)
    # gogrepo
    bash gogrepo.sh
    ;;
  03)
    # 3DS QR
    clear
    ${SUCOMMAND} ../scripts/3ds_qr.sh
    echo "${PAUSEMSG}"
    read -s
    ;;
  05)
    # ROM import SMDB
    clear
    bash romimport.sh
    ;;
  *)
    exit 1
    ;;
  esac
done
