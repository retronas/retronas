#!/bin/bash
#
# retro net example
#

cat << EOD
                             |
                             |
                             |
              +--------------+--------------+
              |              |              |
              |              |              |
    ethernet  | retro     ---+-->   modern  |  wifi (wlan0)
wifi (wlan1)  | 10.99.x      |              |
              |              |              |
              +------+-------+---+---+---+--+
                     |       |   |   |   |
                     |       |   |   |   |   ssh (22/tcp)
                     |       |   |   |   +---------------
         p/service   |       |   |   |    samba (445/tcp)
      ---------------+       |   |   +-------------------
                             |   |     cockpit (9090/tcp)
                                 +-----------------------

EOD
