#!/bin/bash

#set -x

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

  if [ "${#MENU_ARRAY2[@]}" -le 0 ] || [ $(echo ${MENU_ARRAY2[@]} | grep "*" ) ]
  then
    echo "No profiles found"
    PAUSE
    exit 1
  fi

  IFS=";"
  for ITEM in "${MENU_ARRAY2[@]}"
  do

    #TITLE="$(grep -E "^title\s=" "${ITEM}" | cut -d' ' -f3-)"
    UPDATED=$(grep -E "^last_updated\s=" "${ITEM}" | cut -d' ' -f3-)

    [ -z "${TITLE}" ] && TITLE="Unknown"
    [ -z "${UPDATED}" ] && UPDATED="00-00-0000"

    ITEM2=${ITEM##*/}
    ININAME="${ITEM2%%.*}"
    MENU_ARRAY+="$ININAME;$UPDATED;"
  done

  dialog \
    --backtitle "${MENU_NAME}" \
    --title "${MENU_NAME}" \
    --clear \
    --menu "${MENU_BLURB}" ${MW} ${MH} 10 \
    ${MENU_ARRAY[@]} \
    2> ${TDIR}/rn_profile

    CLEAR

    PROFILE="$(cat ${TDIR}/rn_profile)"
    if [ ! -z "$PROFILE" ]
    then
      python3 ${SCDIR}/maint/install-profile.py --profile "${PROFILED}/${PROFILE}.ini"
    else
      exit 1
    fi
}

rn_profile_chooser
