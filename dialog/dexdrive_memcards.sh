#!/bin/bash

#set -x

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}

## If this is run as root, switch to our RetroNAS user
## Manifests and cookies stored in ~/.gogrepo
DROP_ROOT
CLEAR

DEXEXT="*.mc*"
DEXPATH=/data/retronas/saves/sony/playstation1
DEXDEV=/dev/dexdrive0

IFS=";"

case $1 in
  N64)
    DEXEXT="*.n64"
    DEXPATH=/data/retronas/saves/nintendo/nintendo64
    echo "N64 is untested, let me know what raw save format is for N64"
    PAUSE
    exit 0
    ;;
esac

rn_dexdrive_game() {
  local MENU_NAME=dexdrive_gamechooser
  READ_MENU_JSON "${MENU_NAME}"
  READ_MENU_TDESC "${MENU_NAME}"

  MENU_ARRAY=()
  MENU_ARRAY2=()

  MENU_ARRAY2+=("${DEXPATH}"/${DEXEXT})

  if [ "${#MENU_ARRAY2[@]}" -le 0 ] || [ $(echo ${MENU_ARRAY2[@]} | grep "*" ) ]
  then
    echo "No memcards found"
    PAUSE
    exit 1
  fi

  IFS=";"
  for ITEM in "${MENU_ARRAY2[@]}"
  do
    UPDATED=$(stat -c %y "${ITEM}" | awk '{print $1}')
    ITEM2="${ITEM##*/}"
    MEMCARD="${ITEM2%%.*}"
    TYPE=${ITEM2##*.}
    MENU_ARRAY+="$ITEM2;$UPDATED;"
  done

  echo ${MENU_ARRAY[@]}
  
  dialog \
    --backtitle "${MENU_TNAME}" \
    --title "${MENU_TNAME}" \
    --clear \
    --menu "${MENU_BLURB}" ${MW} ${MH} 10 \
    ${MENU_ARRAY[@]} \
    2> ${TDIR}/rn_dexdrive
 
  [ $? -eq 0 ] && rn_dexdrive_image

}

rn_dexdrive_image() {
  CLEAR
  NMEMCARD="$(cat ${TDIR}/rn_dexdrive)"
  echo "Going to write \"${NMEMCARD}\" to ${DEXDEV}"
  if [ ! -z "${NMEMCARD}" ]
  then
    if [ -b ${DEXDEV} ]
    then
      echo "Writing ${NMEMCARD} to ${DEXDEV}, please wait ..."
      dd if="${DEXPATH}/${NMEMCARD}" of=${DEXDEV}
      PAUSE
    else
      echo "No Dex Drive found at ${DEXDEV}"
      PAUSE
      exit 1
    fi
  else
    exit 1
  fi
  PAUSE

}

rn_dexdrive_game