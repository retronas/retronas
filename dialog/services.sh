#!/bin/bash

clear
source /opt/retronas/dialog/retronas.cfg
cd ${DIDIR}

rn_services() {
source /opt/retronas/dialog/retronas.cfg
dialog \
  --backtitle "RetroNAS" \
  --title "RetroNAS Services menu" \
  --clear \
  --menu "Please select an service to check" ${MG} 10 \
  "01" "Main Menu" \
  "02" "Samba" \
  "03" "Netatalk" \
  "04" "EtherDFS" \
  "05" "lighttpd" \
  "06" "ProFTPd" \
  "07" "tftpd-hpa" \
  "08" "OpenSSH" \
  "50" "Syncthing" \
  "51" "Cockpit" \
  "52" "WebOne" \
  2> ${TDIR}/rn_services
}

while true
do
  rn_services
  CHOICE=$( cat ${TDIR}/rn_services )
  PAUSEMSG='Press [Enter] to continue...'
  case ${CHOICE} in
  02)
    # Samba
    clear
    CMD="systemctl status smbd"
    echo "$CMD"
    echo ; $CMD ; echo
    echo "${PAUSEMSG}"
    read -s
    ;;
  03)
    # Netatalk
    clear
    CMD="systemctl status netatalk"
    echo "$CMD"
    echo ; $CMD ; echo
    echo "${PAUSEMSG}"
    read -s
    ;;
  04)
    # EtherDFS
    clear
    CMD="systemctl status etherdfs"
    echo "$CMD"
    echo ; $CMD ; echo
    echo "${PAUSEMSG}"
    read -s
    ;;

  05)
    # lighttpd
    clear
    CMD="systemctl status lighttpd"
    echo "$CMD"
    echo ; $CMD ; echo
    echo "${PAUSEMSG}"
    read -s
    ;;
  06)
    # ProFTPd
    clear
    CMD="systemctl status proftpd"
    echo "$CMD"
    echo ; $CMD ; echo
    echo "${PAUSEMSG}"
    read -s
    ;;
  07)
    # tftpd-hpa
    clear
    CMD="systemctl status tftpd-hpa"
    echo "$CMD"
    echo ; $CMD ; echo
    echo "${PAUSEMSG}"
    read -s
    ;;
  08)
    # OpenSSH
    clear
    CMD="systemctl status ssh"
    echo "$CMD"
    echo ; $CMD ; echo
    echo "${PAUSEMSG}"
    read -s
    ;;
  32)
    # ps3netsrv
    clear
    CMD="systemctl status ps3netsrv"
    echo "$CMD"
    echo ; $CMD ; echo
    echo "${PAUSEMSG}"
    read -s
    ;;
  50)
    # Syncthing file sync tool
    clear
    CMD="systemctl status syncthing"
    echo "$CMD"
    echo ; $CMD ; echo
    echo "${PAUSEMSG}"
    read -s
    ;;
  51)
    # Cockpit
    clear
    CMD="systemctl status cockpit"
    echo "$CMD"
    echo ; $CMD ; echo
    echo "${PAUSEMSG}"
    read -s
    ;;
  52)
    # WebOne
    clear
    CMD="systemctl status webone"
    echo "$CMD"
    echo ; $CMD ; echo
    echo "${PAUSEMSG}"
    read -s
    ;;
  *)
    exit 1
    ;;
  esac
done
