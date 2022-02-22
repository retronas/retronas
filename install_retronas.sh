#!/bin/bash

set -u

GITREPO='https://github.com/danmons/retronas.git'
FORCE=0
TARGET=/opt/retronas/

MYID=$( whoami )

_usage() {
  echo "Usage $0" 
  echo "-h this help"
  echo "-o override git repo/branch to install from"
  echo "-f force re-installation (EXPERT)"
  exit 0
}

if [ "${MYID}" != "root" ]
then
  echo "This script needs to be run as sudo/root"
  echo "Please re-run:"
  echo "sudo $0"
  exit 1
fi

OPTSTRING="fho:"
while getopts $OPTSTRING ARG
do
  case $ARG in
    h)
      _usage
      ;;
    o)
      GITREPO="${OPTARG}"
      ;;
    f)
      FORCE=1
      ;;
  esac
done

# handle existing installations
[ -f ${TARGET}/.git/config ] && [ $FORCE -eq 0 ] && echo "Existing installation pass -f to overwrite" && exit 1
[ -f ${TARGET}/.git/config ] && [ $FORCE -eq 1 ] && echo "Installation exists, -f passed, removing" && rm -rf "${TARGET}"


echo
echo "Updating repo cache..."
apt update

echo
echo "Installing necessary tools..."
apt install -y ansible git dialog jq

if [ ! -f ${TARGET}/.git/config ]
then
  echo
  echo "Downloading RetroNAS...from ${GITREPO}"
  cd /opt
  git clone "$GITREPO"
  chmod a+x /opt/retronas/retronas.sh

  if [ $? -eq 0 ]
  then

    #installing a simple starup script
    echo -e '!#/bin/bash\n\nsudo /opt/retronas/retronas.sh $*' > /usr/local/bin/retronas
    chmod a+x /usr/local/bin/retronas

    echo
    echo "All done.  You can now run the RetroNAS config tool with the following command:"
    echo
    echo "retronas"
    echo
  else
    echo "Installation FAILED, check previous messages"
  fi
fi