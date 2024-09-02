#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}

## If this is run as root, switch to our RetroNAS user
DROP_ROOT
CLEAR

rn_import_system() {

  local MENU_NAME=romimportsystem
  READ_MENU_JSON "${MENU_NAME}"
  READ_MENU_TDESC "${MENU_NAME}"
  DLG_MENUJ "${MENU_TNAME}" 10 "${MENU_BLURB}"
  

    while read -r LINE; do
        LINE_ARR=($LINE)
        STR=${LINE_ARR[0]}
        SUB="id"
        if [[ "$STR" == *"$SUB"* ]]; then
            SYSTEMS+=${LINE_ARR[1]}' '
        fi
    done < <(/opt/retronas/scripts/romimport.sh -l)

    I=2
    for S in $SYSTEMS:
    do
        SYSTEM_ARR[$I]=$S
        ((++I))
    done

  while true
  do
    source $_CONFIG
    
    case ${CHOICE} in
      01)
        EXIT_OK
      ;;
      [0-9][0-9])
        CLEAR
        /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[10#$CHOICE]}
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