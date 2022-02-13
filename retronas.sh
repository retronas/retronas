#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG

DISABLE_GITOPS=0
CF="$RNDIR/ansible/retronas_vars.yml"

# Check ROOT
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
  echo "-d show disclaimer"
  echo "-g disable git operations"
  echo "-l show license"
  echo "-t terminal choice (current|vterm)"
  exit 0
}

OPTSTRING="hdgt:"
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
      TCHOICE=${"":-OPTARG}
      ;;
    d)
      # redisplay agreement
      [ -f $AGREEMENT ] && rm -f $AGREEMENT
      ;;
    l)
      # display license
      cat $RNDIR/LICENSE
      ;;
  esac
done

#### DO NOT TOUCH THE SYSTEM UNTIL USER AGREES TO DISCLAIMER
bash $RNDIR/dialog/disclaimer.sh
[ $? -ne 0 ] && echo "User did not accept terms of use, exiting" && exit 1


### Setup the ansible_vars file
cd $RNDIR
if [ -f "${ANCFG}" ]
then
  echo "Config file exists, not creating it"
else
  echo "Config file missing, creating it"
  cp "${ANCFG}.default" "${ANCFG}"
fi

# check if apt was updated in the last 24 hours
if find /var/cache/apt -maxdepth 1 -type f -mtime -1 -exec false {} +
then
  echo "APT repositories are old, syncing..."
  apt update
fi

### Manage install through git
if [ $DISABLE_GITOPS -eq 0 ]
then
  echo "Fetching latest RetroNAS scripts..."
  git config pull.rebase false
  git reset --hard HEAD
  git pull
else
  echo "Skipping script updates, git operations were disabled"
fi

### Set term emulation
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

### Start RetroNAS
echo "Running RetroNAS..."
cd dialog
bash retronas_main.sh
