#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

update_config() {
  local CHECK=$1
  local MATCH=$2
  local VALUE=$3

  # added retronas_group
  if [ -z "${CHECK}" ]
  then
    grep "${MATCH}" ${ANCFG}
    if [ $? -ne 0 ]
    then
      echo "${MATCH}: \"${VALUE}\"" >> ${ANCFG}
    else
      sed -i "s/${MATCH}:.*/${MATCH}: \"${VALUE}\"/" ${ANCFG}
    fi
  fi

}

update_config "${OLDRNGROUP}" "retronas_group" "${OLDRNUSER}"
# 2024-05-31
update_config "${OLDRETROIF}" "retronas_net_retro_interface" "eth0"
update_config "${OLDMODERNIF}" "retronas_net_modern_interface" "wlan0"
update_config "${OLDRETRODHCP}" "retronas_net_retro_dhcprange" "10.99.1.150,10.1.1.200,6h"
update_config "${OLDRETROROUTER}" "retronas_net_retro_router" "10.99.1.1"
update_config "${OLDRETRONTP}" "retronas_net_retro_ntp" "10.99.1.1"
update_config "${OLDUPDNS1}" "retronas_net_upstream_dns1" "8.8.8.8"
update_config "${OLDUPDNS2}" "retronas_net_upstream_dns2" "8.8.4.4"
update_config "${OLDWIFIINT}" "retronas_net_wifi_interface" "wlan0"
update_config "${OLDWIFISSID}" "retronas_net_wifi_ssid" "retronas"
update_config "${OLDWIFICHANNEL}" "retronas_net_wifi_channel" "6"
update_config "${OLDWIFIHWMODE}" "retronas_net_wifi_hwmode" "g"
update_config "${OLDWIFICC}" "retronas_net_wifi_countrycode" "AU"