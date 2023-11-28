#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}

## If this is run as root, switch to our RetroNAS user
## Manifests and cookies stored in ~/.gogrepo
DROP_ROOT
CLEAR

rn_import_system() {

  local MENU_NAME=romimportsystem
  READ_MENU_JSON "${MENU_NAME}"
  READ_MENU_TDESC "${MENU_NAME}"
  DLG_MENUJ "${MENU_TNAME}" 10 "${MENU_BLURB}"
  

while read -r line; do
    SYSTEMS += ${line[1]} + ' '
done << (/opt/retronas/scripts/romimport.sh -l)

i = 2
for s in SYSTEMS:
    SYSTEM_ARR[i] = $s
    i++


  while true
  do
    source $_CONFIG
    
    case ${CHOICE} in
      01)
        EXIT_OK
      ;;
      02)
        romimport.sh -t ${SYSTEM_ARR[2]}
      ;;
      03)
        romimport.sh -t ${SYSTEM_ARR[3]}
      ;;
      04)
        romimport.sh -t ${SYSTEM_ARR[4]}
      ;;
      05)
        romimport.sh -t ${SYSTEM_ARR[5]}
      ;;
      06)
        romimport.sh -t ${SYSTEM_ARR[6]}
      ;;
      07)
        romimport.sh -t ${SYSTEM_ARR[7]}
      ;;
      08)
        romimport.sh -t ${SYSTEM_ARR[8]}
      ;;
      09)
        romimport.sh -t ${SYSTEM_ARR[9]}
      ;;
      10)
        romimport.sh -t ${SYSTEM_ARR[10]}
      ;;
      11)
        romimport.sh -t ${SYSTEM_ARR[11]}
      ;;
      12)
        romimport.sh -t ${SYSTEM_ARR[12]}
      ;;
      13)
        romimport.sh -t ${SYSTEM_ARR[13]}
      ;;
      14)
        romimport.sh -t ${SYSTEM_ARR[14]}
      ;;
      15)
        romimport.sh -t ${SYSTEM_ARR[15]}
      ;;
      16)
        romimport.sh -t ${SYSTEM_ARR[16]}
      ;;
      17)
        romimport.sh -t ${SYSTEM_ARR[17]}
      ;;
      18)
        romimport.sh -t ${SYSTEM_ARR[18]}
      ;;
      19)
        romimport.sh -t ${SYSTEM_ARR[19]}
      ;;
      20)
        romimport.sh -t ${SYSTEM_ARR[20]}
      ;;
      21)
        romimport.sh -t ${SYSTEM_ARR[21]]}
      ;;
      22)
        romimport.sh -t ${SYSTEM_ARR[22]}
      ;;
      23)
        romimport.sh -t ${SYSTEM_ARR[23]}
      ;;
      24)
        romimport.sh -t ${SYSTEM_ARR[24]}
      ;;
      25)
        romimport.sh -t ${SYSTEM_ARR[25]}
      ;;
      26)
        romimport.sh -t ${SYSTEM_ARR[26]}
      ;;
      27)
        romimport.sh -t ${SYSTEM_ARR[27]}
      ;;
      28)
        romimport.sh -t ${SYSTEM_ARR[28]}
      ;;
      29)
        romimport.sh -t ${SYSTEM_ARR[29]}
      ;;
      30)
        romimport.sh -t ${SYSTEM_ARR[30]}
      ;;
      *)
      EXIT_CANCEL
      ;;
      
    esac
    unset CHOICE
  done
}

rn_import_system