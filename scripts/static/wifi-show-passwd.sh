#!/bin/bash

set -u

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

#HOSTAPD_CONF=/etc/hostapd/hostapd-retronas.conf
#if [ -f "${HOSTAPD_CONF}" ]
#then
#        CLEAR
#        PASS="$(sed -rn 's/^wpa_passphrase=(.*)/\1/p' HOSTAPD_CONF)"
#        SSID="$(sed -rn 's/^ssid=(.*)/\1/p' $NMWIFIAP_CONF)"
#        echo "SSID: $SSID PASS:$PASS"
#fi

NMWIFIAP_CONF=/etc/NetworkManager/system-connections/wifi-retronas.nmconnection
if [ -f "${NMWIFIAP_CONF}" ]
then
        CLEAR
        nmcli device wifi show-password
else
        echo "Wireless AP is not installed"
fi

PAUSE
