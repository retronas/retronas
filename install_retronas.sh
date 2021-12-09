#!/bin/bash

MYID=$( whoami )

if [ "${MYID}" != "root" ]
then
  echo "This script needs to be run as sudo/root"
  echo "Please re-run:"
  echo "sudo $0"
  exit 1
fi

echo
echo "Updating repo cache..."
apt update

echo
echo "Installing necessary tools..."
apt install -y git

echo
echo "Downloading RetroNAS..."
cd /opt
git clone 'https://github.com/danmons/retronas.git'

echo
echo "All done.  You can now run the RetroNAS config tool with the following command:"
echo
echo "sudo /opt/retronas/retronas.sh"
echo
