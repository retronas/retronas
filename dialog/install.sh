#!/bin/bash

clear
_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}

rn_install_chooser() {
  source $_CONFIG
  READ_MENU_JSON "install"
  local MENU_BLURB="\nPlease select an option to install"
  DLG_MENUJ "Main Menu" 10 "${MENU_BLURB}"
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
  case ${CHOICE} in
  01)
    clear
    exit 0
    ;;
  02)
    # Samba
    clear
    rn_install_deps
    YAML=install_samba.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  03)
    # Netatalk2
    clear
    rn_install_deps
    YAML=install_netatalk2x.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  04)
    # Netatalk3
    clear
    rn_install_deps
    YAML=install_netatalk3.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  05)
    # EtherDFS
    clear
    rn_install_deps
    YAML=install_etherdfs.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  06)
    # lighttpd
    clear
    rn_install_deps
    YAML=install_lighttpd.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  07)
    # ProFTPd
    clear
    rn_install_deps
    YAML=install_proftpd.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  08)
    # tftpd-hpa
    clear
    rn_install_deps
    YAML=install_tftpd-hpa.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  09)
    # OpenSSH
    clear
    rn_install_deps
    YAML=install_openssh.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  10)
    # Telnet
    clear
    rn_install_deps
    YAML=install_telnet.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  11)
    # NFS
    clear
    rn_install_deps
    YAML=install_nfs.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  12)
    # TNFS ZX Spectrum
    clear
    rn_install_deps
    YAML=install_tnfs.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  20)
    # pygopherd
    clear
    rn_install_deps
    YAML=install_pygopherd.yml rn_install_execute
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
    YAML=install_romdir.yml rn_install_execute
    YAML=install_ps2_openps2loader.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  32)
    # ps3netsrv
    clear
    rn_install_deps
    YAML=install_romdir.yml rn_install_execute
    YAML=install_ps3netsrv.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  33)
    # MiSTer FPGA CIFS
    clear
    rn_install_deps
    YAML=install_samba.yml rn_install_execute
    YAML=install_romdir.yml rn_install_execute
    YAML=install_mister_cifs.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  34)
    # Microsoft XBox360
    clear
    rn_install_deps
    YAML=install_samba.yml rn_install_execute
    YAML=install_romdir.yml rn_install_execute
    YAML=install_xbox360.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  35)
    # gogrepo
    clear
    rn_install_deps
    YAML=install_gogrepo.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  36)
    # romimport smbd
    clear
    rn_install_deps
    YAML=install_romdir.yml rn_install_execute
    YAML=install_romimport.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  37)
    # gcn + swiss fspd
    clear
    rn_install_deps
    YAML=install_romdir.yml rn_install_execute
    YAML=install_fsp.yml rn_install_execute
    echo "${PAUSEMSG}"
    read -s
    ;;
  38)
    # sabretools
    clear
    rn_install_deps
    YAML=install_dotnetcore3.yml rn_install_execute
    YAML=install_sabretools.yml rn_install_execute
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
    YAML=install_cockpit-packages.yml rn_install_execute
    #YAML=install_cockpit-retronas.yml rn_install_execute
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
