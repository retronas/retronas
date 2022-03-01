#!/bin/bash
#
# Ansible wrapper to trigger playbooks 
# or roles through tags
#
set -u

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG

PREFIX=install_
SUFFIX=.yml

ANSCMD="/usr/bin/ansible-playbook"

cd "${ANDIR}"

[ -z "${1}" ] && echo "No options passed" && exit 1
[ ! -f ${ANSCMD} ] && echo "Ansible is not installed, install it first" && exit 1

IFS=';' read -r -a PLAYBOOKS <<< "${1}"

[ ${PLAYBOOKS[#]} -eq 0 ] && echo "Failed to read args, exiting"  && exit 1

function run_ansible {
    local PLAYBOOK="${ANDIR}/${PREFIX}${1}${SUFFIX}"

    [ ! -f ${PLAYBOOK} ] && echo "Failed to find playbook for $1" && exit 1
    ${ANSCMD} -vv "${PLAYBOOK}"
}

run_ansible retronas_dependancies
for PLAYBOOK in ${PLAYBOOKS[@]}
do
    run_ansible $PLAYBOOK
done
