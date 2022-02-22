#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

# DEFAULTS
DEVICE="/dev/ttyUSB0"
LISTEN=23456
SPEED=9600
INIT=Z
ADDN=""
MODE="PHYSICAL"

clear
source $_CONFIG
cd ${DIDIR}

MODE=${1:-PHYSICAL}

rn_tcpser_edit() {

  if [ $MODE == "VIRTUAL" ]
  then
    DEVICE=25232
  fi

  TCPSER_TMP="/tmp/rn_tcpser_edit"
  TCPSER_CONFIG_PATH=/opt/retronas/etc/tcpser
  TCPSER_CONFIG=${TCPSER_CONFIG_PATH}/tcpser-${LISTEN}

  dialog \
    --backtitle "RetroNAS" \
    --title "RetroNAS TCPServ menu" \
    --clear \
    --form "TCPServ Device Config \
    \n\nConfig path: $TCPSER_CONFIG_PATH \
    \n\nLegend: \
    \n- VIRTUAL: VICE RS232 mode \
    \n- PHYSICAL: for USB/Real serial ports \
    \n\nAttention: \
    \n- A Device is considered unique by listen port. \
    \n- Configurations are not read in from existing. \
    \n- This port config will be overwritten on close." \
    25 55 8 \
    "Device:"      1 5 "$DEVICE"  1 20 20 20 \
    "Listen Port:" 2 5 "$LISTEN"  2 20 20 20 \
    "Speed:"       3 5 "$SPEED"   3 20 20 20 \
    "Init String:" 4 5 "$INIT"    4 20 20 20 \
    "Additional"   5 5 "$ADDN"    5 20 20 20 \
    "Mode"         6 5 "$MODE"    6 20 20 20 \
    2>$TCPSER_TMP

}

rn_tcpser_write_envfile() {
  local INPUT="$1"
  readarray -t DATA < "$INPUT"

  if [ "${#DATA[1]}" -gt 1 ]
  then
    local TCPSER_CONFIG=/opt/retronas/etc/tcpser/tcpser-${DATA[1]}

    [ ${#DATA[0]} -le 1 ] && DATA[0]=$DEVICE
    [ ${#DATA[2]} -le 1 ] && DATA[2]=$SPEED
    [ ${#DATA[3]} -le 1 ] && DATA[3]=$INIT
    [ ${#DATA[4]} -le 1 ] && DATA[4]=$ADDN
    [ ${#DATA[5]} -le 1 ] && DATA[5]=$MODE

    DEVSTR="d"
    [ ${DATA[5]} == "VIRTUAL" ] && DEVSTR="v"

    echo "DEVICE=-${DEVSTR}${DATA[0]}" > "${TCPSER_CONFIG}"
    echo "LISTEN=-p${DATA[1]}" >> "${TCPSER_CONFIG}"
    echo "SPEED=-s${DATA[2]}"  >> "${TCPSER_CONFIG}"
    echo "INIT=-i${DATA[3]}"   >> "${TCPSER_CONFIG}"
    echo "ADDN=${DATA[4]}"     >> "${TCPSER_CONFIG}"
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
  case ${CHOICE} in
  *)
    rn_tcpser_write_envfile $TCPSER_TMP 
    exit 1
    ;;
  esac
done
