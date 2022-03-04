#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}
CONFIRM=0
CLEAR

rn_etherdfs_if() {
  source $_CONFIG 
  local MENU_NAME=set-etherdfs-nic
  READ_MENU_TDESC "${MENU_NAME}"
  DLG_INPUTBOX "${MENU_TNAME}" "${MENU_BLURB}" ${OLDETHERDFSIF}

  NEWETHERDFSIF=$CHOICE
  CHOICE=""

  if [ $CONFIRM -eq 0 ]
  then
    if [ ! -z ${NEWETHERDFSIF} ] 
    then
      if [ "${NEWETHERDFSIF}" != "${OLDETHERDFSIF}" ]
      then
        # Confirm the input
        CONFIRM=1
        rn_etherdfs_if_confirm $NEWETHERDFSIF
      else
        echo "Inteface not changed"
      fi
    else 
      echo "User cancelled dialog"
    fi
  fi


}

rn_etherdfs_if_confirm() {
  NEWETHERDFSIF="${1}"
  local MENU_NAME=set-etherdfs-nic-confirm
  READ_MENU_TDESC "${MENU_NAME}"
  DLG_YN "${MENU_TNAME}" "${MENU_BLURB}"
  case ${CHOICE} in
    0)
      source $_CONFIG

      # check for valid interface input
      INTS=$(ip link show | awk '/^[0-9]/{gsub(/:/,"");print $2}')
      if [ $(echo ${INTS[*]} | grep -qF docker0) ]
      then
        # Yes, change the value
        # Delete the old value
        sed -i '/retronas_etherdfs_interface:/d' "${ANCFG}"
        # Add the new value and re-source
        echo "retronas_etherdfs_interface: \"${NEWETHERDFSIF}\"" >> "${ANCFG}"
        source $_CONFIG
        exit 0
      else
        echo "${NEWETHERDFSIF} is not a valid ip interface, please confirm your choice"
        PAUSE
        rn_etherdfs_if
      fi
      ;;
    *)
      # No, exit
      exit ${CHOICE}
      ;;
  esac
}

# Choose the interface
rn_etherdfs_if