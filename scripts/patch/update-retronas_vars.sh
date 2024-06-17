#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
export ANDCFG=${ANDIR}/retronas_vars.yml.default

update_config() {
  local CHECK=$1
  local MATCH=$2
  local FORCE=$3
  local FVAL=$4

  if [ -z "${CHECK}" ]
  then
    if ! grep "${MATCH}" ${ANCFG} > /dev/null
    then
      # look up defaults
      if grep "${MATCH}" ${ANDCFG} > /dev/null
      then
        VALUE=$(awk "/^${MATCH}:/{gsub(/\"/,\"\");print \$2}" ${ANDCFG} )
        echo "${MATCH}: \"${VALUE}\"" >> ${ANCFG}
      else
        echo "Failed to match on $MATCH the default config may be broken"
        exit 1
      fi
    else
      if [ $FORCE -ne 0 ]
      then
        sed -i "s/${MATCH}:.*/${MATCH}: \"${FVAL}\"/" ${ANCFG}
      fi
    fi
  fi
}

#########################################################################################################
#            |CHECK                  |MATCH                                      |FORCE    |VALUE
update_config "${OLDRNGROUP}"         "retronas_group"                            1        "${OLDRNUSER}"
# 2024-05-31 - networking
update_config "${OLDRETROIF}"         "retronas_net_retro_interface"              0
update_config "${OLDMODERNIF}"        "retronas_net_modern_interface"             0
update_config "${OLDRETRODHCP}"       "retronas_net_retro_dhcprange"              0
update_config "${OLDRETROROUTER}"     "retronas_net_retro_router"                 0
update_config "${OLDRETRONTP}"        "retronas_net_retro_ntp"                    0
update_config "${OLDRETROIP}"         "retronas_net_retro_ip"                     0
update_config "${OLDRETROSUBNET}"     "retronas_net_retro_subnet"                 0
update_config "${OLDRETRODNS}"        "retronas_net_retro_dns"                    0
update_config "${OLDUPDNS1}"          "retronas_net_upstream_dns1"                0
update_config "${OLDUPDNS2}"          "retronas_net_upstream_dns2"                0
update_config "${OLDWIFIINT}"         "retronas_net_wifi_interface"               0
update_config "${OLDWIFISSID}"        "retronas_net_wifi_ssid"                    0
update_config "${OLDWIFICHANNEL}"     "retronas_net_wifi_channel"                 0
update_config "${OLDWIFIHWMODE}"      "retronas_net_wifi_hwmode"                  0
update_config "${OLDWIFICC}"          "retronas_net_wifi_countrycode"             0
update_config "${OLDWIFIIP}"          "retronas_net_wifi_ip"                      0
update_config "${OLDWIFISUBNET}"      "retronas_net_wifi_subnet"                  0
update_config "${OLDWIFIDHCP}"        "retronas_net_wifi_dhcprange"               0
update_config "${OLDWIFIROUTER}"      "retronas_net_wifi_router"                  0
update_config "${OLDWIFINTP}"         "retronas_net_wifi_ntp"                     0
update_config "${OLDWIFIDNS}"         "retronas_net_wifi_dns"                     0
# 2024-06-10
update_config "${OLDW3DSQRIP}"        "retronas_net_3dsqr_interface"              0