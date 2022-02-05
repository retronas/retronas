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
  \nThis uses Frédéric Mahé's Python scripts and Smokemonster's SMDB databases to import ROMs. \
  \n
  \nROMs are matched by checksum, renamed and placed into the matching directory structure via space-saving hard links. \
  \n
  \nExisting ROMs will never be overwritten. \
  \n
  \nIf ROMs fail to import, it means you have a ROM with a checksum not in the database (or maybe the file is bad?), or the system type is not yet added. \
  \n
  \nPlace ROMs in the import directory above (use SMB/CIFS/AFP/FTP/SCP/SFTP/whatever) first. Do you wish to proceed?"  ${MG}
}

# Confirm the input
rn_romimport
CHOICE="$?"
PAUSEMSG='Press [Enter] to continue...'

case ${CHOICE} in
  0)
    # Yes, run it
    clear
    if [ -f "${RNDIR}/scripts/romimport.sh" ]
    then
      ${SUCOMMAND} ${RNDIR}/scripts/romimport.sh
    else
      echo "Cannot find ROM import tool. Please install it from the Install Things menu."
    fi
    echo "${PAUSEMSG}"
    read -s
    ;;
  *)
    # No, exit
    exit ${CHOICE}
    ;;
esac
