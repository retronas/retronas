#!/bin/bash

echo "Starting"

cd /opt/retronas

# Create config file
CF="ansible/retronas_vars.yml"
if [ -f "${CF}" ]
then
  echo "Config file exists, not creating it"
else
  echo "Config file missing, creating it"
  cp "${CF}.default" "${CF}"
fi

source /opt/retronas/dialog/retronas.cfg

cd ${ANDIR}
export ANSIBLE_CONFIG=${ANDIR}/ansible.cfg

ansible-playbook retronas_dependencies.yml
# Create romdir
ansible-playbook install_romdir.yml
# Create mister cifs share
## TODO: make this optionated
ansible-playbook install_mister_filesystem.yml

## Little hack
echo "Waiting"
while :
do
	sleep 1
done

