#!/bin/bash

clear
_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}

DROP_ROOT

rn_romimport() {
  source $_CONFIG

  local MENU_BLURB="Import from: ${OLDRNPATH}/romimport \
  \n\nOutput to: ${OLDRNPATH}/roms
  \n\nThis uses Frédéric Mahé's Python scripts and Smokemonster's SMDB databases to import ROMs. \
  \n\nROMs are matched by checksum, renamed and placed into the matching directory structure via space-saving hard links. \
  \n\nExisting ROMs will never be overwritten. \
  \n\nIf ROMs fail to import, it means you have a ROM with a checksum not in the database (or maybe the file is bad?), or the system type is not yet added. \
  \n\nPlace ROMs in the import directory above (use SMB/CIFS/AFP/FTP/SCP/SFTP/whatever) first. Do you wish to proceed?"

  DLG_YN "Confirm" "${MENU_BLURB}"

  # Confirm the input
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
      PAUSE
      ;;
    *)
      # No, exit
      exit ${CHOICE}
      ;;
  esac

}

rn_romimport