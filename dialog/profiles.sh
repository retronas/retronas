#!/bin/bash

set -x

clear
_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
PROFILED="${OLDRNPATH}/config"

cd ${DIDIR}

DROP_ROOT
CLEAR

if [ ! -d "${PROFILED}" ]
then
    echo "${PROFILED} not found, exiting"
    PAUSE
    exit 1
fi

rn_profile_chooser() {
  local MENU_NAME=profiles
  READ_MENU_JSON "${MENU_NAME}"
  READ_MENU_TDESC "${MENU_NAME}"

  MENU_ARRAY=()
  MENU_ARRAY2+=("$PROFILED"/*.ini )

  for ITEM in "${MENU_ARRAY2[@]}"
  do
    ITEM2=${ITEM##*/}
    ITEM3=${ITEM2%%.*}
    MENU_ARRAY+="$ITEM3 $ITEM2 "
  done

  dialog \
    --backtitle "${MENU_NAME}" \
    --title "${MENU_NAME}" \
    --clear \
    --menu "${MENU_BLURB}" ${MW} ${MH} 10 \
    ${MENU_ARRAY[@]} \
    2> ${TDIR}/rn_profile

    CLEAR
    python3 ${SCDIR}/maint/install-profile.py --profile "${PROFILED}/$(cat ${TDIR}/rn_profile).ini"

}

rn_profile_chooser
