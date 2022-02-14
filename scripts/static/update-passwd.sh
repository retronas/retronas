#!/bin/bash

set -u -x

USERNAME=$(whoami)

echo "Updating systems password for $USERNAME"
PASSWD="${1}"
echo -e "${PASSWD}\n${PASSWD}" | sudo passwd $USERNAME

SMB_SYSTEMD=$(systemctl show smbd.service --full --property FragmentPath --value)
if [ ! -z "${SMB_SYSTEMD}" ] && [ -f "${SMB_SYSTEMD}" ]
then
    echo "Updating samba password for $(whoami)"
    echo -e "${PASSWD}\n${PASSWD}" | sudo smbpasswd -s -a $USERNAME 2>/dev/null
fi