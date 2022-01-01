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

CF="ansible/retronas_vars.yml"

if [ -f "${CF}" ]
then
  echo "Config file exists, not creating it"
else
  echo "Config file missing, creating it"
  cp "${CF}.default" "${CF}"
fi

echo "Syncing repos..."
apt update

echo "Installing prerequisits packages..."
apt install -y ansible git dialog

echo "Fetching latest RetroNAS scripts..."
git reset --hard HEAD
git pull

clear
echo
echo "Please choose your terminal encoding:"
echo
echo "1) Current - ${TERM} [DEFAULT]"
echo "2) vt100 (best for telnet and retro computers)"
echo
read TCHOICE

case "${TCHOICE}" in
  2*)
    echo "Setting TERM to vt100"
    export TERM=vt100
    ;;
  *)
    echo "Leaving TERM as ${TERM}"
    ;;
esac

echo "Running RetroNAS..."
cd dialog
bash retronas_main.sh
