#!/bin/bash
#
_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

cat << EOD
# standalone option
#
# retro network is available on both ethernet and wifi intefaces
#
# a wifi access point is available to connect retro devices
#
# internet access must be provided through an additional (temporary interface)
#

                             |
                             |
               ingress       |       ingress
              +--------------+--------------+
              |              |              |
    ethernet  | retro              retro-ap |  wifi 
     (eth0)   | 10.99.1             10.99.2 | (wlan0)
              |              |              |
              +--------------+--------------+
                             | ssid: retronas
                             | pass: retronas
                             |
EOD

PAUSE