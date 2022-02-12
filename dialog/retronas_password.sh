#!/bin/bash

_CONFIG=/opt/retronas/dialog/retronas.cfg
source $_CONFIG
source ${DIDIR}/common.sh
cd ${DIDIR}

rn_retronas_password() {
  local MENU_BLURB="\nThe current RetroNAS user is \"${OLDRNUSER}\" \
    \n\nIf you are having problems with CIFS/SMB shares, you can reset their password here.
    \n\nProceed?"

  DLG_YN "Password Menu" "${MENU_BLURB}"

  case ${CHOICE} in
    0)
      # Yes, change the password
      clear
      echo
      echo
      echo "Changing the system password for ${OLDRNUSER} :"
      echo
      passwd ${OLDRNUSER}
      echo
      SMB_SYSTEMD=$(systemctl show smbd.service --full --property FragmentPath --value)
      if [ ! -z "${SMB_SYSTEMD}" ] && [ -f "${SMB_SYSTEMD}" ]
      then
        echo "Samba detected. Changing the Samba/SMB/CIFS password for user ${OLDRNUSER} :"
        echo
        smbpasswd -a ${OLDRNUSER} 2>/dev/null
        echo
        systemctl restart avahi-daemon smbd nmbd
        echo
      fi
      echo "${PAUSEMSG}"
      read -s
      exit 0
      ;;
    *)
      # No, exit
      exit ${CHOICE}
      ;;
  esac
}

CLEAR
rn_retronas_password

