#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}

CLEAR

rn_import_system() {

  local MENU_NAME=romimportsystem
  READ_MENU_JSON "${MENU_NAME}"
  READ_MENU_TDESC "${MENU_NAME}"
  DLG_MENUJ "${MENU_TNAME}" 10 "${MENU_BLURB}"
  
    I=2
    while IFS=" ";read -ra LINE; do
        if [[ "${LINE[0]}" == "id:" ]]; then
            SYSTEMS+=${LINE[1]}' '
            SYSTEM_ARR[$I]=${LINE[1]}
            ((++I))
        fi
    done < <(/opt/retronas/scripts/romimport.sh -l)

  while true
  do
    source $_CONFIG
    
    case ${CHOICE} in
      01)
        EXIT_OK
      ;;
      [0-9][0-9])
        CLEAR
        DROP_ROOT /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[10#$CHOICE]}
        PAUSE
      ;;
      *)
      EXIT_CANCEL
      ;;
      
    esac
    unset CHOICE
  done
}

rn_import_system
