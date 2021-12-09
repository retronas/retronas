#!/bin/bash

clear
source /opt/retronas/dialog/retronas.cfg
cd ${DIDIR}

rn_install_chooser() {
source /opt/retronas/dialog/retronas.cfg
dialog \
  --backtitle "RetroNAS" \
  --title "RetroNAS Installation menu" \
  --clear \
  --menu "Please select an option to install" ${MG} 10 \
  "01" "Main Menu" \
  "02" "Samba - LANMan, NetBIOS, NetBEUI, SMB, CIFS file sharing" \
  "03" "Netatalk - AppleTalk, AFP file sharing" \
  "04" "EtherDFS - lightweight layer 2 network file sharing for DOS" \
  "05" "lighttpd - HTTP/Web server" \
  "06" "ProFTPd - FTP, File Transfer Protocol file sharing" \
  "07" "tftpd-hpa - TFTP, Trivial File Transfer Protocol file sharing" \
  "08" "OpenSSH - SSH/SFTP/SCP Secure Shell command line and file transfer" \
  "30" "Nintendo 3DS QR code generator for FBI Homebrew" \
  "31" "Sony PS2 OpenPS2Loader SMB config" \
  "32" "Sony PS3 ps3netsrv for CFW/HEN + webMAN-MOD" \
  "50" "Syncthing file sync tool" \
  "51" "Cockpit web based Linux system manager" \
  "52" "WebOne - HTTP 1.x proxy for a HTTP 2.x world" \
  2> ${TDIR}/rn_install
}

rn_install_deps() {
cd ${ANDIR}
export ANSIBLE_CONFIG=${ANDIR}/ansible.cfg
ansible-playbook retronas_dependencies.yml
}

rn_install_execute() {
cd ${ANDIR}
export ANSIBLE_CONFIG=${ANDIR}/ansible.cfg
ansible-playbook ${YAML}
}

while true
do
  rn_install_chooser
  CHOICE=$( cat ${TDIR}/rn_install )
  PAUSEMSG='Press [Enter] to continue...'
  case ${CHOICE} in
  02)
    # Samba
    clear
    rn_install_deps
    YAML=install_samba.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  03)
    # Netatalk
    clear
    rn_install_deps
    YAML=install_netatalk.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  04)
    # EtherDFS
    clear
    rn_install_deps
    YAML=install_etherdfs.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;

  05)
    # lighttpd
    clear
    rn_install_deps
    YAML=install_lighttpd.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  06)
    # ProFTPd
    clear
    rn_install_deps
    YAML=install_proftpd.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  07)
    # tftpd-hpa
    clear
    rn_install_deps
    YAML=install_tftpd-hpa.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  08)
    # OpenSSH
    clear
    rn_install_deps
    YAML=install_openssh.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  30)
    # Nintendo 3DS QR Codes
    clear
    rn_install_deps
    YAML=install_lighttpd.yml rn_install_execute
    YAML=install_3ds_qr_codes.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  31)
    # Sony PS2 OpenPS2Loader
    clear
    rn_install_deps
    YAML=install_samba.yml rn_install_execute
    YAML=install_ps2_openps2loader.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  32)
    # ps3netsrv
    clear
    rn_install_deps
    YAML=install_ps3netsrv.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  50)
    # Syncthing file sync tool
    clear
    rn_install_deps
    YAML=install_syncthing.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  51)
    # Cockpit
    clear
    rn_install_deps
    YAML=install_filesystems.yml rn_install_execute
    YAML=install_cockpit.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  52)
    # WebOne
    clear
    rn_install_deps
    YAML=install_dotnetcore3.yml rn_install_execute
    YAML=install_webone.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  *)
    exit 1
    ;;
  esac
done
