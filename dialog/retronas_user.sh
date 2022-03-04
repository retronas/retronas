#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}

CONFIRM=0

rn_retronas_user() {
  source $_CONFIG
  local MENU_NAME=update-user
  READ_MENU_TDESC "${MENU_NAME}"
  DLG_INPUTBOX "${MENU_TNAME}" "${MENU_BLURB}" ${OLDRNUSER}

  NEWRNUSER=${CHOICE}
  CHOICE=""

  if [ $CONFIRM -eq 0 ]
  then
    if [ ! -z ${NEWRNUSER} ] 
    then
      if [ "${NEWRNUSER}" != "${OLDRNUSER}" ]
      then
        # Confirm the input
        CONFIRM=1
        rn_retronas_user_confirm $NEWRNUSER
      else
        CLEAR
        echo "Username not changed"
      fi
    else 
      CLEAR
      echo "User cancelled dialog"
    fi
  fi

}

rn_retronas_user_confirm() {
  local MENU_NAME=update-user-confim
  local NEWRNUSER="${1}"
  READ_MENU_TDESC "${MENU_NAME}"
  DLG_YN "${MENU_TNAME}" "${MENU_BLURB}"

  while true
  do
    case ${CHOICE} in
      0)
        source $_CONFIG
        # Test the value
        getent passwd ${NEWRNUSER} &> /dev/null
        if [ $? -ne 0 ] 
        then 
          CLEAR
          echo "Username does not exist, create it first"
          PAUSE
          rn_retronas_user
        else
          CLEAR
          # Yes, change the value
          # Delete the old value
          sed -i '/retronas_user:/d' "${ANCFG}"
          # Add the new value and re-source
          echo "retronas_user: \"${NEWRNUSER}\"" >> "${ANCFG}"
          source $_CONFIG
          EXIT_OK
        fi
        ;;
      *)
        # No, exit
        exit
        ;;
    esac
  done
}

# Choose the user
rn_retronas_user

