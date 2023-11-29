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
    for s in $SYSTEMS:
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
      0[2-9]|[1-2][0-9]|30)
        CLEAR
        /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[$CHOICE]}
        PAUSE
      ;;
      # 03)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[3]}
      #   PAUSE
      # ;;
      # 04)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[4]}
      #   PAUSE
      # ;;
      # 05)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[5]}
      #   PAUSE
      # ;;
      # 06)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[6]}
      #   PAUSE
      # ;;
      # 07)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[7]}
      #   PAUSE
      # ;;
      # 08)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[8]}
      #   PAUSE
      # ;;
      # 09)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[9]}
      #   PAUSE
      # ;;
      # 10)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[10]}
      #   PAUSE
      # ;;
      # 11)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[11]}
      #   PAUSE
      # ;;
      # 12)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[12]}
      #   PAUSE
      # ;;
      # 13)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[13]}
      #   PAUSE
      # ;;
      # 14)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[14]}
      #   PAUSE
      # ;;
      # 15)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[15]}
      #   PAUSE
      # ;;
      # 16)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[16]}
      #   PAUSE
      # ;;
      # 17)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[17]}
      #   PAUSE
      # ;;
      # 18)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[18]}
      #   PAUSE
      # ;;
      # 19)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[19]}
      #   PAUSE
      # ;;
      # 20)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[20]}
      #   PAUSE
      # ;;
      # 21)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[21]]}
      #   PAUSE
      # ;;
      # 22)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[22]}
      #   PAUSE
      # ;;
      # 23)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[23]}
      #   PAUSE
      # ;;
      # 24)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[24]}
      #   PAUSE
      # ;;
      # 25)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[25]}
      #   PAUSE
      # ;;
      # 26)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[26]}
      #   PAUSE
      # ;;
      # 27)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[27]}
      #   PAUSE
      # ;;
      # 28)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[28]}
      #   PAUSE
      # ;;
      # 29)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[29]}
      #   PAUSE
      # ;;
      # 30)
      #   CLEAR
      #   /opt/retronas/scripts/romimport.sh -t ${SYSTEM_ARR[30]}
      #   PAUSE
      # ;;
      *)
      PAUSE
      EXIT_CANCEL
      ;;
      
    esac
    unset CHOICE
  done
}

rn_import_system