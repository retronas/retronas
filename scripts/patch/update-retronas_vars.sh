#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

# added retronas_group
if [ -z "${OLDRNGROUP}" ]
then
  grep "retronas_group" ${ANCFG}
  if [ $? -ne 0 ]
  then
    echo "retronas_group: \"${OLDRNUSER}\"" >> ${ANCFG}
  else
    sed -i "s/retronas_group:.*/retronas_group: \"${OLDRNUSER}\"/" ${ANCFG}
  fi
fi

# added interfaces
if [ -z "${OLDRETROIF}" ]
then
  grep "retronas_net_retro_interface" ${ANCFG}
  if [ $? -ne 0 ]
  then
    echo "retronas_net_retro_interface: \"eth0\"" >> ${ANCFG}
  else
    sed -i "s/retronas_net_retro_interface:.*/retronas_net_retro_interface: \"eth0\"/" ${ANCFG}
  fi
fi


if [ -z "${OLDMODERNIF}" ]
then
  grep "retronas_net_modern_interface" ${ANCFG}
  if [ $? -ne 0 ]
  then
    echo "retronas_net_modern_interface: \"wlan0\"" >> ${ANCFG}
  else
    sed -i "s/retronas_net_modern_interface:.*/retronas_net_modern_interface: \"wlan0\"/" ${ANCFG}
  fi
fi