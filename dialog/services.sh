#!/bin/bash

_CONFIG=/opt/retronas/dialog/retronas.cfg
source $_CONFIG
cd ${DIDIR}

#
# GENERIC function to call a command format output
#
rn_service_status() {
  source $_CONFIG
  local CMD="$1"

  clear
  echo "${CMD}"
  echo ; $CMD ; echo
  echo "${PAUSEMSG}"
  read -s
}

#
# SYSTEMD status checks
#
rn_systemd_status() {
  source $_CONFIG
  local SERVICE="$1"
  local SC="systemctl --no-pager --full"

  rn_service_status "${SC} status ${SERVICE}"

}

#
# DIRECTLY call a status command, and pass args
#
rn_direct_status() {
  source $_CONFIG
  local SERVICE="$1"
  local ARGS="$2"

  if [ -x "$(which $SERVICE)" ]
  then
    rn_service_status "${SERVICE} ${ARGS}"
  fi

}

rn_services() {
  source $_CONFIG
  dialog \
    --backtitle "RetroNAS" \
    --title "RetroNAS Services menu" \
    --clear \
    --menu "My IP addresses: ${MY_IPS} \
    \n
    \nPlease select an service to check" ${MG} 10 \
    "01" "Main Menu" \
    "02" "Samba" \
    "03" "Netatalk3" \
    "04" "EtherDFS" \
    "05" "lighttpd" \
    "06" "ProFTPd" \
    "07" "tftpd-hpa" \
    "08" "OpenSSH" \
    "09" "Telnet" \
    "12" "TNFS for XZ Spectrum" \
    "50" "Syncthing" \
    "51" "Cockpit" \
    "52" "WebOne" \
    2> ${TDIR}/rn_services
}

clear
while true
do
  rn_services
  CHOICE=$( cat ${TDIR}/rn_services )
  PAUSEMSG='Press [Enter] to continue...'
  case ${CHOICE} in
  02)
    # Samba
    rn_systemd_status "smbd"
    rn_direct_status "smbstatus" "-vv"
    ;;
  03)
    # Netatalk3
    rn_systemd_status "netatalk"
    ;;
  04)
    # EtherDFS
    rn_systemd_status "etherdfs"
    ;;

  05)
    # lighttpd
    rn_systemd_status "lighttpd"
    ;;
  06)
    # ProFTPd
    rn_systemd_status "proftpd"
    ;;
  07)
    # tftpd-hpa
    rn_systemd_status "tftpd-hpa"
    ;;
  08)
    # OpenSSH
    rn_systemd_status "ssh"
    ;;
  09)
    # Telnet
    rn_systemd_status "inetd"
    ;;
  12)
    # TNFS ZX Spectrum
    rn_systemd_status "tnfsd"
    ;;
  32)
    # ps3netsrv
    rn_systemd_status "ps3netsrv"
    ;;
  50)
    # Syncthing file sync tool
    rn_systemd_status "syncthing@${OLDRNUSER}"
    ;;
  51)
    # Cockpit
    rn_systemd_status "cockpit"
    ;;
  52)
    # WebOne
    rn_systemd_status "webone"
    ;;
  *)
    exit 1
    ;;
  esac
done
