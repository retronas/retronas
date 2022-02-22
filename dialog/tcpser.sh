#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}

CLEAR
rn_tcpser() {
source $_CONFIG
dialog \
  --backtitle "RetroNAS" \
  --title "RetroNAS TCPServ menu" \
  --clear \
  --menu "My IP addresses: ${MY_IPS} \
  \n
  \nPlease select an option" ${MG} 10 \
  "01" "Back" \
  "02" "Install tcpser service" \
  "03" "Create/Edit Device" \
  "04" "Create/Edit Virtual Device (VICE RS232)" \
  "05" "Start Modem" \
  "06" "Query Modem" \
  "07" "Stop Modem" \
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
      
  if [ ! -z $LISTEN ] && [ -f /opt/retronas/etc/tcpser/tcpser-$LISTEN ]
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
  01)
    clear
    exit 0
    ;;
  02)
    # tcpser
    CLEAR
    RN_INSTALL_DEPS
    RN_INSTALL_EXECUTE install_tcpser.yml
    PAUSE
    ;;
  03)
    # create new modem
    bash tcpser_edit.sh
    ;;
  04)
    # create new virtual modem
    bash tcpser_edit.sh VIRTUAL
    ;;
  05)
    # start modem
    tcpser_service START
    ;;
  06)
    # query modem
    tcpser_service STATUS
    ;;
  07)
    # start modem
    tcpser_service STOP
    ;;
  *)
    exit 1
    ;;
  esac
done
