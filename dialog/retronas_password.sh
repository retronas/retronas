#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=update-password
cd ${DIDIR}

rn_retronas_password() {
  READ_MENU_TDESC "${MENU_NAME}"
  DLG_YN "${MENU_TNAME}" "${MENU_BLURB}"

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
      echo
      ATALK_SYSTEMD=$(systemctl show atalkd.service --full --property FragmentPath --value)
      if [ ! -z "${ATALK_SYSTEMD}" ] && [ -f "${ATALK_SYSTEMD}" ]
      then
        echo "AppleTalk detected. Changing the AppleTalk password for user ${OLDRNUSER} :"
        echo
        touch /opt/retronas/bin/netatalk2x/etc/netatalk/afppasswd
        /opt/retronas/bin/netatalk2x/bin/afppasswd -a ${OLDRNUSER}
        echo
        echo "Restarting AppleTalk, this can take 45 seconds or longer..."
        systemctl restart avahi-daemon atalkd afpd
        echo
      fi
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
}

CLEAR
rn_retronas_password

