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

while true
do
  rn_install_chooser
  case ${CHOICE} in
  01)
    CLEAR
    exit 0
    ;;
  02)
    # Samba
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_samba.yml
    PAUSE
    ;;
  03)
    # Netatalk2
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_netatalk2x.yml
    PAUSE
    ;;
  04)
    # Netatalk3
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_netatalk3x.yml
    PAUSE
    ;;
  05)
    # EtherDFS
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_etherdfs.yml
    PAUSE
    ;;
  06)
    # lighttpd
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_lighttpd.yml
    PAUSE
    ;;
  07)
    # ProFTPd
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_proftpd.yml
    PAUSE
    ;;
  08)
    # tftpd-hpa
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_tftpd-hpa.yml
    PAUSE
    ;;
  09)
    # OpenSSH
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_openssh.yml
    PAUSE
    ;;
  10)
    # Telnet
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_telnet.yml
    PAUSE
    ;;
  11)
    # NFS
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_nfs.yml
    PAUSE
    ;;
  12)
    # TNFS ZX Spectrum
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_tnfs.yml
    PAUSE
    ;;
  20)
    # pygopherd
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_pygopherd.yml
    PAUSE
    ;;
  30)
    # Nintendo 3DS QR Codes
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_lighttpd.yml
    RN_INSTALL_EXECUTE install_3ds_qr_codes.yml
    PAUSE
    ;;
  31)
    # Sony PS2 OpenPS2Loader
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_samba.yml
    RN_INSTALL_EXECUTE install_romdir.yml
    RN_INSTALL_EXECUTE install_ps2_openps2loader.yml
    PAUSE
    ;;
  32)
    # ps3netsrv
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_romdir.yml
    RN_INSTALL_EXECUTE install_ps3netsrv.yml
    PAUSE
    ;;
  33)
    # MiSTer FPGA CIFS
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_samba.yml
    RN_INSTALL_EXECUTE install_romdir.yml
    RN_INSTALL_EXECUTE install_mister_cifs.yml
    PAUSE
    ;;
  34)
    # Microsoft XBox360
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_samba.yml
    RN_INSTALL_EXECUTE install_romdir.yml
    RN_INSTALL_EXECUTE install_xbox360.yml
    PAUSE
    ;;
  35)
    # gogrepo
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_gogrepo.yml
    PAUSE
    ;;
  36)
    # romimport smbd
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_romdir.yml
    RN_INSTALL_EXECUTE install_romimport.yml
    PAUSE
    ;;
  37)
    # gcn + swiss fspd
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_romdir.yml
    RN_INSTALL_EXECUTE install_fsp.yml
    PAUSE
    ;;
  38)
    # sabretools
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_dotnetcore3.yml
    RN_INSTALL_EXECUTE install_sabretools.yml
    PAUSE
    ;;
  50)
    # Syncthing file sync tool
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_syncthing.yml
    PAUSE
    ;;
  51)
    # Cockpit
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_filesystems.yml
    RN_INSTALL_EXECUTE install_cockpit.yml
    RN_INSTALL_EXECUTE install_cockpit-packages.yml
    #RN_INSTALL_EXECUTE install_cockpit-retronas.yml
    PAUSE
    ;;
  52)
    # WebOne
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_dotnetcore3.yml
    RN_INSTALL_EXECUTE install_webone.yml
    PAUSE
    ;;
  *)
    exit 1
    ;;
  esac
done
