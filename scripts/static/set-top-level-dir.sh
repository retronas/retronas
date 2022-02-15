#!/bin/bash -x

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

NEWRNPATH="${1}"

[ ! -d "${NEWRNPATH}" ] && echo "Directory does not exist" && exit 1

# Delete the old value
sudo sed -i '/retronas_path:/d' "${ANCFG}"
# Add the new value and re-source
echo "retronas_path: \"${NEWRNPATH}\"" | sudo tee -a "${ANCFG}"