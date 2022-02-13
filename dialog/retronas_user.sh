#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}
CONFIRM=0

rn_retronas_user() {
  source $_CONFIG

  local MENU_BLURB="Please enter the username for all RetroNAS services to run as. \
  \n\nThis is currently \"${OLDRNUSER}\" \
  \n\nThis will normally default to \"pi\" on a default Rasberry Pi OS install. \
  \n\nIt is recommended you leave it as default unless you know what you are doing."

  DLG_INPUTBOX "User Configuration" "${MENU_BLURB}" ${OLDRNUSER}

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
        echo "Username not changed"
      fi
    else 
      echo "User cancelled dialog"
    fi
  fi

}

rn_retronas_user_confirm() {
  local NEWRNUSER="${1}"
  local MENU_BLURB="\nDo you want to save this setting? \
  \nNewRetroNAS user: \"${NEWRNUSER}\""

  DLG_YN "Confirm" "${MENU_BLURB}"

  while true
  do
    case ${CHOICE} in
      0)
        source $_CONFIG
        # Test the value
        getent passwd ${NEWRNUSER} &> /dev/null
        if [ $? -ne 0 ] 
        then 
          echo "Username does not exist, create it first"
          PAUSE
          rn_retronas_user
        else
          # Yes, change the value
          # Delete the old value
          sed -i '/retronas_user:/d' "${ANCFG}"
          # Add the new value and re-source
          echo "retronas_user: \"${NEWRNUSER}\"" >> "${ANCFG}"
          source $_CONFIG
          exit 0
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

