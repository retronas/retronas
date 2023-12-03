#!/bin/bash


_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=imgcreator-details
cd ${DIDIR}


# DEFAULTS
NAME="rn-$(mktemp -u | cut -d'.' -f2)"
VOLUME=""

source $_CONFIG
cd ${DIDIR}

PROFILE=${1}

if [ -z $PROFILE ]
then
  echo "Profile was not passed to menu, cannot continue"
  PAUSE
  exit 1
fi

if [ ! -f "${OLDRNPATH}/config/formats/$PROFILE.fmt" ]
then
  echo "Profile was not found, cannot continue"
  PAUSE
  exit 1
fi

rn_imgcreator_details() {

  READ_MENU_TDESC "${MENU_NAME}"

  MENU_ARRAY=(
    "Name:*"      1 5 "$NAME"     1 20 20 20
    "Volume:"     2 5 "$VOLUME"   2 20 20 20
    "Profile:"    3 5 "$PROFILE"  3 20 20 20
  )

  DLG_FORM "${MENU_TNAME}" "${MENU_ARRAY}" 4 "${MENU_BLURB}"

  if [ ${#CHOICE[@]} -gt 0 ]
  then
    if [ "${#CHOICE[1]}" -gt 1 ]
    then
      CLI_OPTS=""
      [ ! -z $VOLUME ] && CLI_OPTS+=" -v $VOLUME"
      ${SCDIR}/imgcreator.sh -p "${PROFILE}.fmt" -n $NAME $CLI_OPTS
      PAUSE
    fi
  fi

}

DROP_ROOT
rn_imgcreator_details

