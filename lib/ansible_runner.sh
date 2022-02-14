#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG

PREFIX=install_
SUFFIX=.yml

PLAYBOOK="${ANDIR}/${PREFIX}${1}${SUFFIX}"
ANSCMD="/usr/bin/ansible-playbook"

cd "${ANDIR}"

[ -z "${1}" ] && echo "No options passed" && exit 1
[ ! -f ${PLAYBOOK} ] && echo "Failed to find playbook for $1" && exit 1
[ ! -f ${ANSCMD} ] && echo "Ansible is not installed, install it first" && exit 1

${ANSCMD} -vv "${PLAYBOOK}"
