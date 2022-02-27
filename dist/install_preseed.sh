#!/bin/sh

#
# This is intended to be used to preseed a debian iso
# as part of d-i preseed/late_command
#

if [ -f /opt/retronas/retronas_deployed ]
then
    /usr/bin/curl -so /tmp/install_retronas.sh https://raw.githubusercontent.com/danmons/retronas/main/install_retronas.sh
    /usr/bin/chmod a+x /tmp/install_retronas.sh
    /tmp/install_retronas.sh

    cd /opt/retronas/ansible

    cp retronas_vars.yml.default retronas_vars.yml

    /usr/bin/ansible-playbook -vv retronas_dependencies.yml
    /usr/bin/ansible-playbook -vv install_filesystems.yml
    /usr/bin/ansible-playbook -vv install_cockpit.yml
    /usr/bin/ansible-playbook -vv install_cockpit-packages.yml
    #/usr/bin/ansible-playbook -vv install_cockpit-retronas.yml

    touch /opt/retronas/retronas_deployed
fi