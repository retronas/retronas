#!/bin/bash

set -u

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh


USERNAME=${OLDRNUSER}
PASSWD="${1}"

[ -z "$PASSWD" ] && echo "No password supplied, exiting" && PAUSE && EXIT_CANCEL

echo "Updating system password for $USERNAME"
echo -e "${PASSWD}\n${PASSWD}" | sudo passwd $USERNAME 2>/dev/null

SMB_SYSTEMD=$(systemctl show smbd.service --full --property FragmentPath --value)
if [ ! -z "${SMB_SYSTEMD}" ] && [ -f "${SMB_SYSTEMD}" ]
then
    echo "Updating Samba password for $USERNAME"
    echo -e "${PASSWD}\n${PASSWD}" | sudo smbpasswd -s -a $USERNAME 2>/dev/null
fi

ATALK_SYSTEMD=$(systemctl show atalkd.service --full --property FragmentPath --value)
if [ ! -z "${ATALK_SYSTEMD}" ] && [ -f "${ATALK_SYSTEMD}" ]
then
    ATALKDIR=/opt/retronas/bin/netatalk2x
    echo "Updating AppleTalk password for $USERNAME"
    touch ${ATALKDIR}/etc/netatalk/afppasswd
    ${ATALKDIR}/bin/afpexpect.sh -a "${USERNAME}" "${PASSWD}" 2>/dev/null
fi