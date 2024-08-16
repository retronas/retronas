#!/bin/bash

set -u

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

PASSWD="${1}"

[ -z "$PASSWD" ] && echo "No password supplied, exiting" && PAUSE && EXIT_CANCEL

#HOSTAPD_CONF=/etc/hostapd/hostapd-retronas.conf
#if [ -f "${HOSTAPD_CONF}" ]
#then
#        sed -ri "/^wpa_passphrase=/d" $HOSTAPD_CONF 2>/dev/null
#        if sed "wpa_passphrase=${PASSWD}" >> $HOSTAPD_CONF # 2>/dev/null
#        then
#                echo "wifi password updated successfully"
#        fi
#else
#        echo "Config file not found, assuming hostapd is not installed"
#fi

NMWIFIAP_CONF=/etc/NetworkManager/system-connections/wifi-retronas.conf
if [ -f "${NMWIFIAP_CONF}" ]
then
        if nmcli connection modify wifi-retronas wifi-sec.psk "${PASSWD}"
        then
                echo "Password updated successfully"
        fi
else
        echo "Wireless AP is not installed"
fi