#!/bin/sh

#
# This is intended to be used to preseed a debian iso
# as part of d-i preseed/late_command
#

/usr/bin/curl -so /tmp/install_retronas.sh https://raw.githubusercontent.com/danmons/retronas/main/install_retronas.sh
/usr/bin/chmod a+x /tmp/install_retronas.sh
/tmp/install_retronas.sh

cd /opt/retronas/ansible
/usr/bin/ansible-playbook -vv retronas_dependencies.yml
/usr/bin/ansible-playbook -vv install_filesystems.yml
/usr/bin/ansible-playbook -vv install_cockpit.yml
/usr/bin/ansible-playbook -vv install_cockpit-packages.yml
/usr/bin/ansible-playbook -vv install_cockpit-retronas.yml