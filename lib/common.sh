#!/bin/bash

set -u

export SC="systemctl --no-pager --full"

###############################################################################
#
# Logging
#
###############################################################################

#
# use RN_LOG instead of echo, so we can centralise logging approach
#
RN_LOG() {
    echo "${1}"
}

###############################################################################
#
# Package
#
###############################################################################
CHECK_PACKAGE_CACHE() {
    case $1 in
        *)
            # check if apt was updated in the last 24 hours
            if find /var/cache/apt -maxdepth 1 -type f -mtime -1 -exec false {} +
            then
                echo "APT repositories are old, syncing..."
                apt update
            fi
            ;;
    esac
}


###############################################################################
#
# GENERAL reusable functions
#
###############################################################################

#
# Compare two values
#
COMPARE_VALUES() {
    local STROLD=$1
    local STRNEW=$2
    export CONFIRM=0

    if [ ! -z ${STRNEW} ] 
    then
      if [ "${STRNEW}" != "${STROLD}" ]
      then
        # Confirm the input
        #CHECK_USER_EXISTS $STRNEW $STROLD
        export CONFIRM=1
      else
        CLEAR
        RN_LOG "Item not changed"
        PAUSE
      fi
    else 
      CLEAR
      RN_LOG "No values to process"
      PAUSE
    fi
}

#
# CONFIRM A VALUE
#
CONFIRM_VALUE() {
    echo $1
}

###############################################################################
#
# PRIVILEGE handlers
#
###############################################################################

## If this is run as root, switch to our RetroNAS user
DROP_ROOT() {
  sudo -u ${OLDRNUSER} -s $*
}

### Check if we have the correct privs for op
CHECK_ROOT() {
    [ $UID -ne 0 ] && echo "You must run this as root, try sudo <command>" && exit 1
}

###############################################################################
#
# LANGUAGE handlers
#
###############################################################################

### Get LANG file
GET_LANG() {
    [ ! -z "${LANG}" ] && RNLANG=$(echo $LANG | awk -F'_' '{print $1}')
    [ -z ${RNLANG} ] && RNLANG="en"
    
    if [ -f ${LANGDIR}/${RNLANG} ]
    then
        source ${LANGDIR}/${RNLANG}
    else
        echo "Failed to load language file, check config is complete"
        exit 1
    fi

}

###############################################################################
#
# MENU data loaders
#
###############################################################################

#
# Read menu items from the json config
# export the data for use in dialogs
#
READ_MENU_TDESC() {
    export MENU_TITLE="$1"
    export MENU="$2"

    # handle submenus
    [ -z "$MENU" ] && MENU="menu"

    if [ -f ${RNJSON}/${MENU_TITLE}.json ]
    then
        local MENU_TDESC_DATA=$(<${RNJSON}/${MENU_TITLE}.json jq -r ".\"${MENU}\" | \"\(.title);\(.description)\"")
    elif [ -f ${RNJSONOLD} ]
    then
        local MENU_TDESC_DATA=$(<${RNJSONOLD} jq -r ".dialog.\"${MENU_TITLE}\" | \"\(.title);\(.description)\"")
    else
        local MENU_TDESC_DATA=$(<${RNJSON}/main.json jq -r ".menu | \"\(.title);\(.description)\"")    
    fi
    local IFS=$'\n'

    IFS=";" read -r -a PIECES <<< ${MENU_TDESC_DATA}
    export MENU_TNAME=${PIECES[0]}
    # eval ... yes i'm so terribly sorry
    export MENU_BLURB=$(eval "echo $(echo ${PIECES[@]:1} | sed 's/|/\\\\n/g')" )
}

#
# Read menu items from the json config
# export the data for use in dialogs
#
READ_MENU_JSON() {
    local MENU_TITLE="${1}"
    local MENU="${2}"

    # handle submenus
    [ -z "$MENU" ] && MENU="menu"

    if [ -f ${RNJSON}/${MENU_TITLE}.json ]
    then
        export MENU_DATA=$(<${RNJSON}/${MENU_TITLE}.json jq -r ".\"${MENU}\".items[] | \"\(.index)|\(.title)|\(.description)|\(.type)\"")
    elif [ -f ${RNJSONOLD} ]
    then
        export MENU_DATA=$(<${RNJSONOLD} jq -r ".dialog.\"${MENU}\".items[] | \"\(.index)|\(.title)|\(.description);\"")
    else
        export MENU_DATA=$(<${RNJSON}/main.json jq -r ".menu.items[] | \"\(.index)|\(.title)|\(.description);\"")
    fi
}

#
# Looks up the menu item in the json file. returns both type and command values
# type determines the action taken
# command is a colon separated list of actions taken by helper functions
#
READ_MENU_COMMAND() {
    local MENU_NAME="$1"
    local MENU_CHOICE=$2

    cd "${RNDIR}"

    if [ -f ${RNJSON}/${MENU_TITLE}.json ]
    then
        MENU_DATA=$(<${RNJSON}/${MENU_TITLE}.json jq -r ".menu.items[] | select(.index == \"${MENU_CHOICE}\") | \"\(.type)|\(.command)|\(.args)\"")
    elif [ -f ${RNJSONOLD} ]
    then
        MENU_DATA=$(<${RNJSONOLD} jq -r ".dialog.${MENU_NAME}.items[] | select(.index == \"${MENU_CHOICE}\") | \"\(.type)|\(.command)\"")
    else
        MENU_DATA=$(<${RNJSON}/main.json jq -r ".menu.items[] | select(.index == \"${MENU_CHOICE}\") | \"\(.type)|\(.command)|\(.args)\"")
    fi

    IFS="|" read -r -a PIECES <<< ${MENU_DATA}
    local MENU_TYPE=${PIECES[0]}
    local MENU_SELECT=${PIECES[1]}
    local MENU_ARGS=${PIECES[@]:2}

    CLEAR
    if [ ! -z "${MENU_SELECT}" ] && [ "${MENU_SELECT}" != "null" ]
    then 
        case $MENU_TYPE in
            install)
                RN_INSTALL_EXECUTE $MENU_SELECT
                ;;
            modal)
                EXEC_SCRIPT "m-${MENU_SELECT}"
                ;;
            dialog)
                EXEC_SCRIPT "d-${MENU_SELECT}"
                ;;
            dialog_input)
                EXEC_SCRIPT "i-${MENU_SELECT}"
                ;;
            dialog_yn)
                EXEC_SCRIPT "y-${MENU_SELECT}"
                ;;
            form)
                EXEC_SCRIPT "f-${MENU_SELECT}"
                ;;
            script)
                EXEC_SCRIPT $MENU_SELECT $MENU_ARGS
                ;;
            script-static)
                EXEC_SCRIPT "s-${MENU_SELECT}"
                ;;
            service_status)
                RN_SYSTEMD_STATUS "${MENU_SELECT}"
                ;;
            service_enable_start)
                RN_SYSTEMD_ENABLE "${MENU_SELECT}"
                RN_SYSTEMD_START "${MENU_SELECT}"
                ;;
            service_start)
                RN_SYSTEMD_START "${MENU_SELECT}"
                ;;
            service_start_follow)
                RN_SYSTEMD_START "${MENU_SELECT}"
                RN_JOURNAL_FOLLOW "${MENU_SELECT}"
                ;;
            service_restart)
                RN_SYSTEMD_RESTART "${MENU_SELECT}"
                ;;
            service_disable_stop)
                RN_SYSTEMD_DISABLE "${MENU_SELECT}"
                RN_SYSTEMD_STOP "${MENU_SELECT}"
                ;;
            service_stop)
                RN_SYSTEMD_STOP "${MENU_SELECT}"
                ;;
            menu)
                "${MENU_SELECT}"
                ;;
            command)
                bash -c "${MENU_SELECT}"
                ;;
            documentation)
                RN_DOCUMENTATION "${MENU_SELECT}"
                ;;
            *)
                echo "Not supported, why are you here?"
                PAUSE
                ;;
        esac
    else
        echo "Failed to select item for $MENU_CHOICE"
        PAUSE
    fi
    unset MENU_SELECT
}

###############################################################################
#
# EXIT handlers
#
###############################################################################

EXIT_OK() {
    CLEAR
    exit 0
}


EXIT_CANCEL() {
    CLEAR
    exit 1
}

### Clear function, standardised
CLEAR() {
    clear
}

### Wait for user input
PAUSE() {
    echo "${PAUSEMSG}"
    read -s
}

###############################################################################
#
# COMMAND handlers
#
###############################################################################

### Run a script
EXEC_SCRIPT() {
    local SCRIPT="${1}"

    #CLEAR
    #CHECK_PACKAGE_CACHE

    CLEAR
    shift
    /opt/retronas/lib/script_runner.sh "${SCRIPT}" $*

    cd ${DIDIR}
    unset SCRIPT
}

#
# Install Ansible Dependencies, runs with every installer
#
# !!! this function will be deprecated
#
RN_INSTALL_DEPS() {
    source $_CONFIG
    cd ${ANDIR}

    CLEAR
    CHECK_PACKAGE_CACHE

    ansible-playbook -vv retronas_dependencies.yml
    cd ${DIDIR}
}

#
# Run the playbook
#
RN_INSTALL_EXECUTE() {
    source $_CONFIG
    local PLAYBOOK=$1

    CLEAR
    CHECK_PACKAGE_CACHE

    CLEAR
    /opt/retronas/lib/ansible_runner.sh "${PLAYBOOK}"
    PAUSE

    #cd ${ANDIR}
    #ansible-playbook -vv "${PLAYBOOK}"
    cd ${DIDIR}
    unset PLAYBOOK
}

#
# Run the pandoc/lynx
#
RN_DOCUMENTATION() {
    source $_CONFIG
    local DOCUMENTATION=$1

    CLEAR
    /opt/retronas/lib/markup_runner.sh "${DOCUMENTATION}"

    cd ${DIDIR}
    unset DOCUMENTATION
}


###############################################################################
#
# SERVICE query/type handlers
#
###############################################################################

#
# Service status formatting
#
RN_SERVICE_STATUS() {
    local CMD="$1"

    CLEAR
    echo "${CMD}"
    echo ; eval $CMD ; echo
    #PAUSE
}

#
# SYSTEMD status checks
#
RN_SYSTEMD_STATUS() {
    RN_SYSTEMD "${1}" "status"
    PAUSE
}

#
# SYSTEMD enable
#
RN_SYSTEMD_ENABLE() {
    RN_SYSTEMD "${1}" "enable"
}

#
# SYSTEMD start
#
RN_SYSTEMD_START() {
    RN_SYSTEMD "${1}" "start"
}

#
# SYSTEMD restart
#
RN_SYSTEMD_RESTART() {
    RN_SYSTEMD "${1}" "restart"
}

#
# SYSTEMD disable
#
RN_SYSTEMD_DISABLE() {
    RN_SYSTEMD "${1}" "disable"
}

#
# SYSTEMD stop
#
RN_SYSTEMD_STOP() {
    RN_SYSTEMD "${1}" "stop"
}

#
# SYSTEMD
#
RN_SYSTEMD() {
    local SERVICE="$1"
    local COMMAND="${2:-status}"

    RN_SERVICE_STATUS "${SC} ${COMMAND} ${SERVICE}"

}

#
# JOURNAL follow
#
RN_JOURNAL_FOLLOW() {
    journalctl --follow -u "${1}"
}

#
# DIRECTLY call a status command, and pass args
#
RN_DIRECT_STATUS() {
    source $_CONFIG
    local SERVICE="$1"
    local ARGS="$2"

    if [ -x "$(which $SERVICE)" ]
    then
    RN_SERVICE_STATUS "${SERVICE} ${ARGS}"
    fi

}


###############################################################################
#
# DIALOG builder functions
# based on: https://stackoverflow.com/questions/4889187/dynamic-dialog-menu-box-in-bash
#
###############################################################################

#
# MENU
#
DLG_MENUJ() {

    local IFS=$'\n'
    local TITLE="$1"
    local MENU_H=$2
    local MENU_BLURB=$3

    local MENU_DESC="${IPADDMSGNO}${MENU_BLURB}"

    DIALOG=(dialog \
            --backtitle "${APPNAME}" \
            --title "${APPNAME} ${TITLE} Menu" \
            --clear \
            --no-shadow \
            --menu "$MENU_DESC" ${MW} ${MH} ${MENU_H})

    declare -a MENU_ARRAY
    for ITEM in ${MENU_DATA[@]}
    do
        IFS="|" read -r -a PIECES <<< $ITEM
        INDEX=${PIECES[0]}
        TITLE=${PIECES[1]}
        DESC=${PIECES[2]}
        TYPE=${PIECES[3]}

        [ "${TYPE}"  == "dialog" ] && DESC="${DESC} >>"
        MENU_ARRAY+=(${INDEX} "${TITLE} - ${DESC}")
    done

    export CHOICE=$("${DIALOG[@]}" "${MENU_ARRAY[@]}" 2>&1 >/dev/tty)
    unset MENU_ARRAY

}


#
# MENU
#
DLG_MENU() {

    local IFS=$'\n'
    local TITLE="$1"
    MENU_ARRAY=$2
    local MENU_H=$3
    local MENU_BLURB=$4

    local MENU_DESC="${IPADDMSGNO}${MENU_BLURB}"

    DIALOG=(dialog \
            --backtitle "${APPNAME}" \
            --title "${APPNAME} ${TITLE} Menu" \
            --clear \
            --no-shadow \
            --menu "$MENU_DESC" ${MW} ${MH} ${MENU_H})

    export CHOICE=$("${DIALOG[@]}" "${MENU_ARRAY[@]}" 2>&1 >/dev/tty)
    unset MENU_ARRAY

}

#
# YES/NO
#
DLG_YN() {
    local IFS=$'\n'
    local TITLE="$1"
    local MENU_BLURB=$2

    local MENU_DESC="${IPADDMSGNO}${MENU_BLURB}"

    DIALOG=(dialog \
    --backtitle "${APPNAME}" \
    --title "${APPNAME} ${TITLE} Menu" \
    --clear \
    --no-shadow \
    --defaultno \
    --yesno "${MENU_DESC}" ${MW} ${MH})

    "${DIALOG[@]}" 2>&1 >/dev/tty
    export CHOICE=$?
}

#
# DIRECTORY SELECTOR
#
DLG_DSELECT() {
    local IFS=$'\n'
    local TITLE="$1"
    local MENU_BLURB=$2

    local MENU_DESC="${IPADDMSGNO}${MENU_BLURB}"

    DIALOG=(dialog \
    --backtitle "${APPNAME}" \
    --title "${APPNAME} ${TITLE} Menu" \
    --clear \
    --no-shadow \
    --dselect "${MENU_BLURB}" ${MW} ${MH})

    export CHOICE=$("${DIALOG[@]}" 2>&1 >/dev/tty)
}

#
# INPUTBOX SELECTOR
#
DLG_INPUTBOX() {
    local IFS=$'\n'
    local TITLE="$1"
    local MENU_BLURB=$2
    local MENU_INIT=$3

    local MENU_DESC="${IPADDMSGNO}${MENU_BLURB}"

    DIALOG=(dialog \
    --backtitle "${APPNAME}" \
    --title "${APPNAME} ${TITLE} Menu" \
    --clear \
    --no-shadow \
    --inputbox "${MENU_BLURB}" ${MW} ${MH} $MENU_INIT)

    export CHOICE=$("${DIALOG[@]}" 2>&1 >/dev/tty)
}

#
# PASSWORD INPUT
#
DLG_PASSWORD() {
    local IFS=$'\n'
    local TITLE="$1"
    MENU_ARRAY=$2
    local MENU_H=$3
    local MENU_BLURB=$4

    local MENU_DESC="${IPADDMSGNO}${MENU_BLURB}"

    DIALOG=(dialog \
        --backtitle "${APPNAME}" \
        --title "${APPNAME} ${TITLE} Menu" \
        --clear \
        --no-shadow \
        --insecure \
        --passwordform "\n$MENU_DESC" ${MW} ${MH} ${MENU_H})

    export CHOICE=($("${DIALOG[@]}" "${MENU_ARRAY[@]}" 2>&1 >/dev/tty))
    unset MENU_ARRAY
}


#
# FORM INPUT
#
DLG_FORM() {
    local IFS=$'\n'
    local TITLE="$1"
    MENU_ARRAY=$2
    local MENU_H=$3
    local MENU_BLURB=$4

    local MENU_DESC="${IPADDMSGNO}${MENU_BLURB}"

    DIALOG=(dialog \
        --backtitle "${APPNAME}" \
        --title "${APPNAME} ${TITLE} Menu" \
        --clear \
        --no-shadow \
        --form "\n$MENU_DESC" ${MW} ${MH} ${MENU_H})

    export CHOICE=($("${DIALOG[@]}" "${MENU_ARRAY[@]}" 2>&1 >/dev/tty))
    unset MENU_ARRAY
}

set +u
