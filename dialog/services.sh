#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}

rn_services() {

  local MENU_ARRAY=(
    01 "Back"
    02 "Samba"
    03 "Netatalk3"
    04 "EtherDFS"
    05 "lighttpd"
    06 "ProFTPd"
    07 "tftpd-hpa"
    08 "OpenSSH"
    09 "Telnet"
    12 "TNFS for Atari 8-bit and ZX Spectrum"
    32 "ps3netsrv"
    37 "FSP for GameCube"
    50 "Syncthing"
    51 "Cockpit"
    52 "WebOne"
  )

  local MENU_BLURB="Please select an service to check"

  DLG_MENU "Services Menu" $MENU_ARRAY 10 "${MENU_BLURB}"

}

CLEAR
while true
do
  rn_services
  case ${CHOICE} in
  01)
    exit 0
    ;;
  02)
    # Samba
    RN_SYSTEMD_STATUS "smbd"
    RN_DIRECT_STATUS "smbstatus" "-vv"
    ;;
  03)
    # Netatalk3
    RN_SYSTEMD_STATUS "netatalk"
    ;;
  04)
    # EtherDFS
    RN_SYSTEMD_STATUS "etherdfs"
    ;;

  05)
    # lighttpd
    RN_SYSTEMD_STATUS "lighttpd"
    ;;
  06)
    # ProFTPd
    RN_SYSTEMD_STATUS "proftpd"
    ;;
  07)
    # tftpd-hpa
    RN_SYSTEMD_STATUS "tftpd-hpa"
    ;;
  08)
    # OpenSSH
    RN_SYSTEMD_STATUS "ssh"
    ;;
  09)
    # Telnet
    RN_SYSTEMD_STATUS "inetd"
    ;;
  12)
    # TNFS ZX Spectrum
    RN_SYSTEMD_STATUS "tnfsd"
    ;;
  32)
    # ps3netsrv
    RN_SYSTEMD_STATUS "ps3netsrv"
    ;;
  37)
    # fspd gamecube
    RN_SYSTEMD_STATUS "fspd"
    ;;
  50)
    # Syncthing file sync tool
    #RN_SYSTEMD_STATUS "syncthing@${OLDRNUSER}"

    # report on ALL possible syncthing services, see issue #18
    RN_SYSTEMD_STATUS "syncthing*"
    ;;
  51)
    # Cockpit
    RN_SYSTEMD_STATUS "cockpit"
    ;;
  52)
    # WebOne
    RN_SYSTEMD_STATUS "webone"
    ;;
  *)
    exit 1
    ;;
  esac
done
