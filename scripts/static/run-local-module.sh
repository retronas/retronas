#!/bin/bash

#
# allow users to run a playbook from their retronas local config dir
# this will allow for custom managed options for users atop the available
# modules in retronas 
#

RETRONAS_PATH="$(awk -F '"' '/retronas_path/{print $2}' ../../ansible/retronas_vars.yml)"
[ -z $RETRONAS_PATH ] && exit 1
MODULE_PATH="${RETRONAS_PATH}/config/modules"

cd $RETRONAS_PATH/config/modules

if  [ -f $RETRONAS_PATH/config/modules/main.yml ]
then
  ansible-playbook ./main.yml
fi