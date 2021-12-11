#!/bin/bash

MYID=$( whoami )

if [ "${MYID}" != "root" ]
then
  echo "This script needs to be run as sudo/root"
  echo "Please re-run:"
  echo "sudo $0"
  exit 1
fi

cd /opt/retronas

echo "Syncing repos..."
apt update

echo "Installing prerequisits packages..."
apt install -y ansible git dialog

echo "Fetching latest RetroNAS scripts..."
git reset --hard HEAD
git pull

echo "Running RetroNAS..."
cd dialog
bash retronas_main.sh
