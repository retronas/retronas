#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

USERNAME=${OLDRNUSER}

# hack to check if the user exists
smbpasswd -e $USERNAME &> /dev/null
if [ $? -eq 1 ]
then
        # run the smbpasswd config
        cd /opt/retronas/dialog/
        bash retronas_password.sh
fi
