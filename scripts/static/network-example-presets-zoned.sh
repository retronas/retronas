#!/bin/bash
#
_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

cat << EOD
# zoned option
#
# in this mode the the retro network is available on the ethernet interface
# of the pi while access to the modern network in avalable on the wifi interface.
#
# the retro network is able to access services in its own domain. access to the
# main network is provided _out_ of the wifi interface and subsequently the
# internet
# 
# firewalld is used to provide isolation between the networks, traffic is
# permitted out of the wifi interface. Incoming traffic is permitted through
# firewall rulesets

                             |
                             |
               ingress       |        egress
              +--------------+--------------+
              |              |              |
    ethernet  | retro     ---+-->   modern  |  wifi 
     (eth0)   | 10.99.x      |              | (wlan0)
              |              |              |
              +--+---+---+---+---+---+---+--+
                 |   |   |   |   |   |   |
  p/service      |   |   |   |   |   |   |   ssh (22/tcp)
  >--------------+   |   |   |   |   |   +--------------<
  samba              |   |   |   |   |    samba (445/tcp)
  >------------------+   |   |   |   +------------------<
  dhcp|(m)dns|icmp|ntp   |   |   |     cockpit (9090/tcp)
  >----------------------+   |   +----------------------<
EOD

PAUSE