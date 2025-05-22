#!/bin/bash


_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
MENU_NAME=tcpser-edit
cd ${DIDIR}


# DEFAULTS
DEVICE="/dev/ttyUSB0"
LISTEN=23456
SPEED=9600
INIT=Z
ADDN=""
MODE="PHYSICAL"

source $_CONFIG
cd ${DIDIR}

MODE=${1:-PHYSICAL}

rn_tcpser_edit() {

  [ $MODE == "VIRTUAL" ] && DEVICE=25232

  TCPSER_CONFIG_PATH=/opt/retronas/etc/tcpser
  TCPSER_CONFIG=${TCPSER_CONFIG_PATH}/tcpser-${LISTEN}

  READ_MENU_TDESC "${MENU_NAME}"

  MENU_ARRAY=(
    "Device:"      1 5 "$DEVICE"  1 20 20 20
    "Listen Port:" 2 5 "$LISTEN"  2 20 20 20
    "Speed:"       3 5 "$SPEED"   3 20 20 20
    "Init String:" 4 5 "$INIT"    4 20 20 20
    "Additional"   5 5 "$ADDN"    5 20 20 20
    "Mode"         6 5 "$MODE"    6 20 20 20
  )

  DLG_FORM "${MENU_TNAME}" "${MENU_ARRAY}" 8 "${MENU_BLURB}"

  [ ${#CHOICE[@]} -gt 0 ] && rn_tcpser_write_envfile

}

rn_tcpser_write_envfile() {

  if [ "${#CHOICE[1]}" -gt 1 ]
  then
    local TCPSER_CONFIG=/opt/retronas/etc/tcpser/tcpser-${CHOICE[1]}

    [ ${#CHOICE[0]} -le 1 ] && DATA[0]=$DEVICE
    [ ${#CHOICE[2]} -le 1 ] && DATA[2]=$SPEED
    [ ${#CHOICE[3]} -le 1 ] && DATA[3]=$INIT
    [ ${#CHOICE[4]} -le 1 ] && DATA[4]=$ADDN
    [ ${#CHOICE[5]} -le 1 ] && DATA[5]=$MODE

    DEVSTR="d"
    [ ${DATA[5]} == "VIRTUAL" ] && DEVSTR="v"

    echo "DEVICE=-${DEVSTR}${CHOICE[0]}" > "${TCPSER_CONFIG}"
    echo "LISTEN=-p${CHOICE[1]}" >> "${TCPSER_CONFIG}"
    echo "SPEED=-s${CHOICE[2]}"  >> "${TCPSER_CONFIG}"
    echo "INIT=-i${CHOICE[3]}"   >> "${TCPSER_CONFIG}"
    echo "ADDN=${CHOICE[4]}"     >> "${TCPSER_CONFIG}"

    EXIT_OK
    
  else
    echo "No data available for LISTEN port, so we won't be writing a file"
    PAUSE
    rn_tcpser_edit
  fi

}

rn_tcpser_edit

