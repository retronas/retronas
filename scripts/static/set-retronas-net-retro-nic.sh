#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

NEWINT=${1}

if [ ! -z "${NEWINT}" ]
then
    # Delete the old value
    sudo sed -i '/retronas_net_modern_interface:/d' "${ANCFG}"
    # Add the new value and re-source
    echo "retronas_net_modern_interface: \"${NEWINT}\"" | sudo tee -a "${ANCFG}"
else
    echo "int can't be null"
    exit 1
fi
