#!/bin/bash

clear

TARGET_LINUX_VERSION=13
TARGET_LINUX_DISTRO=debian
TARGET_ANSIBLE_VERSION=219
TARGET_ARCH_X86=x86_64
TARGET_ARCH_ARM=aarch64

source /etc/os-release
ANSIBLE_VERSION=$(ansible --version | head -n1 | sed -rn 's/.*\[core (.*)\]/\1/p'i | sed -r 's/\.//g')

ERROR=0
EXIT=1

CHECKMARK=$(printf "\xE2\x9C\x94")
CROSS="x"
COMPAT="SUPPORTED"
INCOMPAT="UN${COMPAT}"
MESSAGE=""

check_result() {
 local RESULT=$1
 if [ $1 -eq 1 ] 
 then
    RESULT=$INCOMPAT
    GLYPH=$CROSS
    ERROR=1
 else
    RESULT=$COMPAT
    GLYPH=$CHECKMARK
 fi
 echo " ${GLYPH} ${MESSAGE}: ${RESULT}"
}

echo -e "... Checking system compatiblity ... \n"

MESSAGE="Ansible version (${ANSIBLE_VERSION})"
[ ${ANSIBLE_VERSION} -lt  ${TARGET_ANSIBLE_VERSION} ] && check_result 1 || check_result 0

MESSAGE="Distro family (${ID})"
[ $ID != $TARGET_LINUX_DISTRO ] && check_result 1 || check_result 0

MESSAGE="Distro release ($VERSION_ID)"
[ $VERSION_ID -lt ${TARGET_LINUX_VERSION} ] && check_result 1 || check_result 0


ARCH=$(uname -m)
MESSAGE="Architecture ($ARCH)"
[[ $ARCH != ${TARGET_ARCH_X86} && $ARCH != ${TARGET_ARCH_ARM} ]] && check_result 1 || check_result 0

if [ $ERROR -ne 0 ]
then
  echo -e "\n!!  We have determined your system is unsupported  !!"
  echo -e "!!     RetroNAS may still work but expect bugs     !!"
  echo -e "\nCheck the documentation for supported configurations"
  EXIT=1
fi

echo ""
exit $EXIT
