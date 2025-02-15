#!/bin/bash

# ansible 2.14 workaround
export LC_ALL=${LANG}

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

DISABLE_GITOPS=0
CF="$ANCFG"
TCHOICE=""

#
# CHECK we are running as ROOT
#
CHECK_ROOT

_usage() {
  echo "Usage $0" 
  echo "-h this help"
  echo "-d show disclaimer"
  echo "-g disable git operations"
  echo "-l show license"
  echo "-t terminal choice (current|vterm)"
  echo "-v run in vt100 mode"
  echo "-a ask for terminal selection at statup"
  exit 0
}

OPTSTRING="hdgvat:"
while getopts $OPTSTRING ARG
do
  case $ARG in
    h)
      _usage
      ;;
    g)
      DISABLE_GITOPS=1
      ;;
    t)
      TCHOICE=${"":-OPTARG}
      ;;
    v)
      TCHOICE=vt100
      ;;
    a)
      TICHOICE="ASK"
      ;;
    d)
      # redisplay agreement
      [ -f $AGREEMENT ] && rm -f $AGREEMENT
      ;;
    l)
      # display license
      cat $RNDIR/LICENSE
      ;;
  esac
done

#### DO NOT TOUCH THE SYSTEM UNTIL USER AGREES TO DISCLAIMER
bash $DIDIR/disclaimer.sh
[ $? -ne 0 ] && echo "User did not accept terms of use, exiting" && EXIT_CANCEL


### ANSIBLE_VARS
cd $RNDIR
if [ -f "${ANCFG}" ]
then
  echo "Config file exists, not creating it"
else
  echo "Config file missing, creating it"
  cp "${ANCFG}.default" "${ANCFG}"
fi
source $_CONFIG

#
# MIGRATIONS
#
bash ${PCHDIR}/update-retronas_vars.sh
bash ${PCHDIR}/install-jq.sh
#
# END MIGRATIONS
#

### source the config to update vars on first run
source $_CONFIG

### LANG UTF-8 patch (this probably needs more testing)
export LANG=$(echo $LANG | sed -r 's/(\.| )UTF(-?)8//gi')

### check default user exists
id $OLDRNUSER &>/dev/null
if [ $? -ne 0 ]
then
  echo -e "The currently configured USER $OLDRNUSER does not exist on this system you will now be prompted to update the config"
  PAUSE
  cd $DIDIR
  bash d_input.sh update-user
fi

### check default group exists
getent group $OLDRNGROUP &>/dev/null
if [ $? -ne 0 ]
then
  echo -e "The currently configured GROUP $OLDRNGROUP does not exist on this system you will now be prompted to update the config"
  PAUSE
  cd $DIDIR
  bash d_input.sh update-group
fi


### Manage install through git
if [ $DISABLE_GITOPS -eq 0 ] && [ ! -f ${USER_CONFIG}/disable_gitops ]
then
  echo "Fetching latest RetroNAS scripts..."
  git config pull.rebase false
  git reset --hard HEAD
  git pull

  if [ -f "${RNDOC}/Ideas.md" ]
  then
    echo "Updating local documentation..."
    cd $RNDOC
    git pull
    cd $RNDIR
  fi

else
  echo "Skipping git updates, git operations were disabled"
fi


### Make sure log dir exists
[ ! -d $LOGDIR ] && mkdir $LOGDIR && chmod 755 $LOGDIR

### Set term emulation,
RNSECONDS=3
if [ "${TICHOICE}" == "ASK" ]
then
  CLEAR
  echo
  echo "Terminal encoding:"
  echo
  echo "1) Current - ${TERM} (default in 3s)"
  echo "2) vt100 (best for telnet and retro computers)"
  echo
  read -r $TCHOICE -t 5 -n 1 -p "Please choose: "
else
  echo "We already know your TERM so moving on"
fi

case "${TCHOICE}" in
  VT100|vt100|2*)
    echo "Setting TERM to vt100"
    export TERM=vt100
    ;;
  *)
    echo "Leaving TERM as ${TERM}"
    ;;
esac

bash ${PCHDIR}/new-startup-file.sh

### Start RetroNAS
echo "Running RetroNAS..."
cd $DIDIR
bash d_menu.sh main
