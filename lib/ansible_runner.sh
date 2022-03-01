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

function run_ansible {
    local PLAYBOOK="${1}"
    [ ! -f ${PLAYBOOK} ] && echo "Failed to find playbook: ${PLAYBOOK}" && exit 1
    ${ANSCMD} -vv "${PLAYBOOK}"
}

[ -z "${1}" ] && echo "No options passed" && exit 1
[ ! -f ${ANSCMD} ] && echo "Ansible is not installed, install it first" && exit 1

IFS=':' read -r -a PLAYBOOKS <<< "${1}"
[ ${#PLAYBOOKS[@]} -eq 0 ] && echo "Failed to read args, exiting"  && exit 1

run_ansible ${ANDIR}/retronas_dependencies.yml
for PLAYBOOK in ${PLAYBOOKS[@]}
do
    run_ansible "${ANDIR}/${PREFIX}${PLAYBOOK}${SUFFIX}"
done
