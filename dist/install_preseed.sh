#!/bin/sh

#
# This is intended to be used to preseed a debian iso
# as part of d-i preseed/late_command
#

curl -so /tmp/install_retronas.sh https://raw.githubusercontent.com/danmons/retronas/main/install_retronas.sh
chmod a+x /tmp/install_retronas.sh
/tmp/install_retronas.sh

cd /opt/retronas/ansible
ansible-playbook -vv retronas_dependencies.yml
ansible-playbook -vv install_filesystems.yml
ansible-playbook -vv install_cockpit.yml
ansible-playbook -vv install_cockpit-packages.yml
ansible-playbook -vv install_cockpit-retronas.yml