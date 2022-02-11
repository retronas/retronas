#!/bin/bash

_CONFIG=/opt/retronas/dialog/retronas.cfg
source $_CONFIG
source ${DIDIR}/common.sh
SERVICE="hdparm"
UNITTYPE="timer"

cd ${DIDIR}

rn_hdparm() {
  source $_CONFIG

  local MENU_ARRAY=(
    01 "Main Menu"
    02 "Install ${SERVICE}"
    10 "Disable Advanced Power Management (APM)"
    11 "Disable Drive Standby"
    20 "Start Service"
    21 "Query Service"
    22 "Stop Service"
  )

  local MENU_BLURB="\n
  \nWARNING: These changes are irreversable, USE AT YOUR OWN RISK \
  \n\nTry in ORDER: \
  \nAPM -> Standby -> Custom service !! LAST RESORT !! <- \
  \n\nThe custom service reads a random sector from the drive at random intervals every 3-5m, this should be enough to keep the drive up and reduce any impact on the drive."

  DLG_MENU "Services Menu" $MENU_ARRAY 10 "${MENU_BLURB}"

}

DROP_ROOT
CLEAR

# Get Available drives
SELECT_DRIVE() {
  
  PS3="Please select a drive ($1): "
  DRIVES="$(grep -E "/dev/(sd|hd)[a-z]+" /proc/mounts | awk '{print $1}') exit"
  select DRIVE in $DRIVES
  do  

    [ $DRIVE == "exit" ] && echo "Exiting..." && exit 0
    
    read -p "Are you sure? [y/N]: " ANSWER

    case $ANSWER in
      y|Y)
        [ ! -z "$DRIVE" ] && echo $DRIVE
        exit
        ;;
      *)  
        SELECT_DRIVE $1
        ;;
    esac
  done
}


while true
do
  rn_hdparm
  case ${CHOICE} in
    01)
      EXEC_SCRIPT retronas_main.sh
      ;;
    02)
      # install
      CLEAR
      RN_INSTALL_DEPS
      RN_INSTALL_EXECUTE install_${SERVICE}.yml 
      PAUSE
      ;;
    10)
      # Advanced Power Management
      CLEAR
      DRIVE=$(SELECT_DRIVE "Disable APM")
      hdparm -B 255 $DRIVE
      PAUSE
      ;;
    11)
      # Drive Standby
      CLEAR
      DRIVE=$(SELECT_DRIVE "Disable Standby")
      hdparm -S 0 $DRIVE
      PAUSE
      ;;
    20)
      # Start Service
      RN_SYSTEMD ${SERVICE}* "reset-failed"
      RN_SYSTEMD_START ${SERVICE}.${UNITTYPE}
      ;;
    21)
      # Query Service
      RN_SYSTEMD_STATUS ${SERVICE}*
      ;;
    22)
      # Stop Service
      RN_SYSTEMD_STOP ${SERVICE}.${UNITTYPE}
      RN_SYSTEMD_STOP ${SERVICE}.service
      ;;
    *)
      exit 1
      ;;
  esac
done
