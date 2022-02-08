#!/bin/bash

DISABLE_GITOPS=0
RN_BASE=/opt/retronas
CF="$RN_BASE/ansible/retronas_vars.yml"

MYID=$( whoami )

if [ "${MYID}" != "root" ]
then
  echo "This script needs to be run as sudo/root"
  echo "Please re-run:"
  echo "sudo $0"
  exit 1
fi

_usage() {
  echo "Usage $0" 
  echo "-h this help"
  echo "-g disable git operations"
  echo "-t terminal choice (current|vterm)"
  exit 0
}

OPTSTRING="hgt:"
while getopts $OPTSTRING ARG
do
  case $ARG in
    h)
      _usage
      ;;
    g)
      DISABLE_GITOPS=1
      ;;
    t)
      TCHOICE=${OPTARG}
      ;;
  esac
done

cd $RN_BASE
if [ -f "${CF}" ]
then
  echo "Config file exists, not creating it"
else
  echo "Config file missing, creating it"
  cp "${CF}.default" "${CF}"
fi


# check if apt was updated in the last 24 hours
if find /var/cache/apt -maxdepth 1 -type f -mtime -1 -exec false {} +
then
  echo "APT repositories are old, syncing..."
  apt update

  echo "Checking prerequisits packages..."
  apt install -y ansible git dialog
fi

if [ $DISABLE_GITOPS -eq 0 ]
then
  echo "Fetching latest RetroNAS scripts..."
  git config pull.rebase false
  git reset --hard HEAD
  git pull
else
  echo "Skipping script updates, git operations were disabled"
fi

if [ -z $TCHOICE ]
then
  clear
  echo
  echo "Please choose your terminal encoding:"
  echo
  echo "1) Current - ${TERM} [DEFAULT]"
  echo "2) vt100 (best for telnet and retro computers)"
  echo
  read TCHOICE
else
  echo "We already know your TERM so moving on"
fi

case "${TCHOICE}" in
  VT100|vt100|2*)
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
