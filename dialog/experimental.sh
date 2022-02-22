#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}
CHOICE=""

rn_advanced() {
  READ_MENU_JSON "experimental"
  local MENU_BLURB="\nWARNING these tools are very EXPERIMENTAL and could break your system or destroy your data! Do not use these unless you are comfortable with losing everthing"
  DLG_MENUJ "EXPERIMENTAL Menu" 10 "${MENU_BLURB}"

}

DROP_ROOT
CLEAR
while true
do
  rn_advanced
  case ${CHOICE} in
  01)
    exit 0
    ;;
  02)
    # experimental webui
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_cockpit-retronas.yml
    PAUSE
    ;;
  03)
    # xboxmanager
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_filesystems.yml
    RN_INSTALL_EXECUTE install_extract-xiso.yml
    RN_INSTALL_EXECUTE install_xbox-manager.yml
    PAUSE
    ;;
  *)
    exit 1
    ;;
  esac
done
