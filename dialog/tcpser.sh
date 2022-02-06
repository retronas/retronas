#!/bin/bash

_CONFIG=/opt/retronas/dialog/retronas.cfg
PAUSEMSG='Press [Enter] to continue...'
clear
source $_CONFIG
cd ${DIDIR}

rn_tcpser() {
source $_CONFIG
dialog \
  --backtitle "RetroNAS" \
  --title "RetroNAS TCPServ menu" \
  --clear \
  --menu "My IP addresses: ${MY_IPS} \
  \n
  \nPlease select an option" ${MG} 10 \
  "01" "Main Menu" \
  "02" "Create/Edit Device" \
  "03" "Create/Edit Virtual Device (VICE RS232)" \
  "04" "Start Modem" \
  "05" "Query Modem" \
  "06" "Stop Modem" \
  2> ${TDIR}/rn_tcpser
}

tcpser_service() {
  source $_CONFIG
  local SC="systemctl --no-pager --full"
  dialog \
    --backtitle "RetroNAS" \
    --title "RetroNAS TCPSer $1 menu" \
    --clear \
    --form "TCPServ Manage Modem \
    \n\nEnter the listen port to $1 the modem" \
    15 55 6 \
    "Listen Port:"        2 5 "" 2 20 20 20 \
    2> ${TDIR}/rn_tcpser_service

  LISTEN=$(cat ${TDIR}/rn_tcpser_service)
      
  if [ !-z $LISTEN && -f /opt/retronas/etc/tcpser/tcpser-$LISTEN ]
  then
    local SERVICE=tcpser@$LISTEN.service
    clear
    case $1 in
      "START")
        $SC restart $SERVICE
        $SC enable $SERVICE
        ;;
      "STATUS")
        $SC status $SERVICE
        echo "${PAUSEMSG}"
        read -s
        ;;
      "STOP")
        $SC stop $SERVICE
        $SC disable $SERVICE
      ;;
    esac
  else
    echo "No modem configuration found for this port, please configure"
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
  rn_tcpser
  CHOICE=$( cat ${TDIR}/rn_tcpser )
  case ${CHOICE} in
  02)
    # create new modem
    bash tcpser_edit.sh
    ;;
  03)
    # create new virtual modem
    bash tcpser_edit.sh VIRTUAL
    ;;
  04)
    # start modem
    tcpser_service START
    ;;
  05)
    # query modem
    tcpser_service STATUS
    ;;
  06)
    # start modem
    tcpser_service STOP
    ;;
  *)
    exit 1
    ;;
  esac
done
