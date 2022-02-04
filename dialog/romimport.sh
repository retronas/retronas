#!/bin/bash

clear
source /opt/retronas/dialog/retronas.cfg
cd ${DIDIR}

## If this is run as root, switch to our RetroNAS user
if [ "${USER}" == "root" ]
then
  SUCOMMAND="sudo -u ${OLDRNUSER}"
else
  SUCOMMAND=""
fi


rn_romimport() {
source /opt/retronas/dialog/retronas.cfg
dialog \
  --backtitle "RetroNAS" \
  --title "ROM Import" \
  --clear \
  --defaultno \
  --yesno "Import from: ${OLDRNPATH}/romimport \
  \n
  \nOutput to: ${OLDRNPATH}/roms
  \n
  \nThis tool uses Smokemonster's SMDB databases to import ROMs. \
  \n
  \nROMs are matched by checksum, renamed and placed into the matching directory structure. \
  \n
  \nExisting ROMs will never be overwritten. \
  \n
  \nIf ROMs fail to import, it means you have a ROM not in the database (maybe the file is bad?) \
  \n
  \nDo you wish to proceed?"  ${MG}
}

# Confirm the input
rn_romimport
CHOICE="$?"

case ${CHOICE} in
  0)
    # Yes, run it
    ${SUCOMMAND} ${RNDIR}/scripts/romimport.sh
    ;;
  *)
    # No, exit
    exit ${CHOICE}
    ;;
esac
