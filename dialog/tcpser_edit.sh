#!/bin/bash

_CONFIG=/opt/retronas/dialog/retronas.cfg

clear
source $_CONFIG
cd ${DIDIR}

MODE=${1:-PHYSICAL}

rn_tcpser_edit() {

  if [ $MODE == "VIRTUAL" ]
  then
    DEVICE=25232

  else
    DEVICE="/dev/ttyUSB0"
  fi
  LISTEN=23456
  SPEED=9600
  INIT=Z

  TCPSER_TMP="/tmp/rn_tcpser_edit"
  TCPSER_CONFIG=/opt/retronas/etc/tcpser/tcpser-${LISTEN}

  dialog \
    --backtitle "RetroNAS" \
    --title "RetroNAS TCPServ menu" \
    --clear \
    --form "TCPServ Device Config" 10 50 6 \
    "Device:"      1 5 "$DEVICE"  1 20 20 20 \
    "Port:"        2 5 "$LISTEN"  2 20 20 20 \
    "Speed:"       3 5 "$SPEED"   3 20 20 20 \
    "Init String:" 4 5 "$INIT"    4 20 20 20 \
    "Mode"         5 5 "$MODE" 5 20 20 20 \
    2>$TCPSER_TMP

}

rn_tcpser_write_envfile() {
  local INPUT="$1"
  readarray -t DATA < "$INPUT"

  if [ ! -z "${DATA[1]}" ]
  then
    local TCPSER_CONFIG=/opt/retronas/etc/tcpser/tcpser-${DATA[1]}

    DEVSTR="d"
    [ ${DATA[4]} == "VIRTUAL" ] && DEVSTR="v"

    echo "DEVICE=-${DEVSTR} ${DATA[0]}" >  "${TCPSER_CONFIG}"
    echo "LISTEN=-p ${DATA[1]}" >> "${TCPSER_CONFIG}"
    echo "SPEED=-s ${DATA[2]}"  >> "${TCPSER_CONFIG}"
    echo "INIT=-i ${DATA[3]}"   >> "${TCPSER_CONFIG}"
  else
    echo "No data available for LISTEN port, so we won't be writing a file"
  fi

}

if [ "${USER}" == "root" ]
then
  SUCOMMAND="sudo -u ${OLDRNUSER}"
else
  SUCOMMAND=""
fi

while true
do
  rn_tcpser_edit
  CHOICE=""
  PAUSEMSG='Press [Enter] to continue...'
  case ${CHOICE} in
  *)
    rn_tcpser_write_envfile $TCPSER_TMP 
    exit 1
    ;;
  esac
done
