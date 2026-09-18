#!/bin/bash

#
# allow users to run a playbook from their retronas local config dir
# this will allow for custom managed options for users atop the available
# modules in retronas 
#

set -u

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

OPTIONS=${1:-}

cd $(dirname $0)
RETRONAS_PATH="$(awk -F '"' '/retronas_path/{print $2}' ../../ansible/retronas_vars.yml)"
[ -z $RETRONAS_PATH ] && exit 1
MODULE_PATH="${RETRONAS_PATH}/config/modules"
[ ! -d $MODULE_PATH ] && exit 1

cd $RETRONAS_PATH/config/modules

if  [ -f $RETRONAS_PATH/config/modules/main.yml ]
then
  ansible-playbook ${OPTIONS} ./main.yml
else
  echo "Local module not found"
fi

PAUSE
