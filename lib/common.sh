#!/bin/bash

set -u

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG

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
## Manifests and cookies stored in ~/.gogrepo
DROP_ROOT() {
    if [ "${USER}" == "root" ]
    then
        export SUCOMMAND="sudo -u ${OLDRNUSER}"
    else
        export SUCOMMAND=""
    fi
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
    local MENU_TITLE="${1:-main}"
    local MENU_TDESC_DATA=$(<${RNJSON} jq -r ".dialog.\"${MENU_TITLE}\" | \"\(.title);\(.description)\"")
    local IFS=$'\n'

    export MENU_TNAME=$(echo $MENU_TDESC_DATA | cut -d";" -f1)
    # eval ... yes i'm so terribly sorry
    export MENU_BLURB=$(eval "echo $(echo $MENU_TDESC_DATA | cut -d";" -f2- | sed 's/|/\\\\n/g')")
}

#
# Read menu items from the json config
# export the data for use in dialogs
#
READ_MENU_JSON() {
    local MENU_TITLE="${1:-main}"
    export MENU_DATA=$(<${RNJSON} jq -r ".dialog.\"${MENU_TITLE}\".items[] | \"\(.index)|\(.title)|\(.description);\"")
}

#
# Looks up the menu item in the json file. returns both type and command values
# type determines the action taken
# command is a colon separated list of actions taken by helper functions
#
READ_MENU_COMMAND() {
    local MENU_NAME=$1
    local MENU_CHOICE=$2

    cd "${RNDIR}"

    MENU_DATA=$(<${RNJSON} jq -r ".dialog.${MENU_NAME}.items[] | select(.index == \"${MENU_CHOICE}\") | \"\(.type)|\(.command)\"")

    local MENU_TYPE=$(echo -e "${MENU_DATA}" | cut -d"|" -f1)
    local MENU_SELECT=$(echo -e "${MENU_DATA}" | cut -d"|" -f2)

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
                EXEC_SCRIPT $MENU_SELECT
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


###############################################################################
#
# SERVICE query/type handlers
#
###############################################################################

#
# Serivce status formatting
#
RN_SERVICE_STATUS() {
    source $_CONFIG
    local CMD="$1"

    CLEAR
    echo "${CMD}"
    echo ; $CMD ; echo
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
    source $_CONFIG
    local SERVICE="$1"
    local COMMAND="${2:-status}"

    RN_SERVICE_STATUS "${SC} ${COMMAND} ${SERVICE}"

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


    local MENU_DESC="${IPADDMSG}${MENU_BLURB}"

    DIALOG=(dialog \
            --backtitle "${APPNAME}" \
            --title "${APPNAME} ${TITLE} Menu" \
            --clear \
            --menu "$MENU_DESC" ${MW} ${MH} ${MENU_H})

    declare -a MENU_ARRAY
    while IFS=";" read -r ITEM
    do

        INDEX=$(echo $ITEM    | cut -d"|" -f1 | tr -d "\n" | sed 's/\s$//') 
        TITLE=$(echo $ITEM    | cut -d"|" -f2 | tr -d "\n" | sed 's/\s$//') 
        DESC=$(echo $ITEM     | cut -d"|" -f3 | tr -d "\n" | sed 's/\s$//') 
        #COMMAND=$(echo $ITEM | cut -d"|" -f4 | tr -d "\n" | sed 's/\s$//')

        MENU_ARRAY+=(${INDEX} "${TITLE} - ${DESC}")


    done < <(echo "${MENU_DATA[@]}")

    export CHOICE=$("${DIALOG[@]}" "${MENU_ARRAY[@]}" 2>&1 >/dev/tty)
    unset MENU_ARRAY

}


#
# MENU
#
DLG_MENU() {

    local IFS=$'\n'
    local TITLE="$1"
    local -n MENU_ARRAY=$2
    local MENU_H=$3
    local MENU_BLURB=$4

    local MENU_DESC="${IPADDMSG}${MENU_BLURB}"

    DIALOG=(dialog \
            --backtitle "${APPNAME}" \
            --title "${APPNAME} ${TITLE} Menu" \
            --clear \
            --menu "$MENU_DESC" ${MW} ${MH} ${MENU_H})

    export CHOICE=$("${DIALOG[@]}" "${MENU_ARRAY[@]}" 2>&1 >/dev/tty)

}

#
# YES/NO
#
DLG_YN() {
    local IFS=$'\n'
    local TITLE="$1"
    local MENU_BLURB=$2

    local MENU_DESC="${IPADDMSG}${MENU_BLURB}"

    DIALOG=(dialog \
    --backtitle "${APPNAME}" \
    --title "${APPNAME} ${TITLE} Menu" \
    --clear \
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

    local MENU_DESC="${IPADDMSG}${MENU_BLURB}"

    DIALOG=(dialog \
    --backtitle "${APPNAME}" \
    --title "${APPNAME} ${TITLE} Menu" \
    --clear \
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

    local MENU_DESC="${IPADDMSG}${MENU_BLURB}"

    DIALOG=(dialog \
    --backtitle "${APPNAME}" \
    --title "${APPNAME} ${TITLE} Menu" \
    --clear \
    --inputbox "${MENU_BLURB}" ${MW} ${MH} $MENU_INIT)

    export CHOICE=$("${DIALOG[@]}" 2>&1 >/dev/tty)

}

#
# PASSWORD INPUT
#
DLG_PASSWORD() {
    local IFS=$'\n'
    local TITLE="$1"
    local -n MENU_ARRAY=$2
    local MENU_H=$3
    local MENU_BLURB=$4

    local MENU_DESC="${IPADDMSG}${MENU_BLURB}"

    DIALOG=(dialog \
        --backtitle "${APPNAME}" \
        --title "${APPNAME} ${TITLE} Menu" \
        --clear \
        --insecure \
        --passwordform "\n$MENU_DESC" ${MW} ${MH} ${MENU_H})

    export CHOICE=($("${DIALOG[@]}" "${MENU_ARRAY[@]}" 2>&1 >/dev/tty))

}


#
# FORM INPUT
#
DLG_FORM() {
    local IFS=$'\n'
    local TITLE="$1"
    local -n MENU_ARRAY=$2
    local MENU_H=$3
    local MENU_BLURB=$4

    local MENU_DESC="${IPADDMSG}${MENU_BLURB}"

    DIALOG=(dialog \
        --backtitle "${APPNAME}" \
        --title "${APPNAME} ${TITLE} Menu" \
        --clear \
        --form "\n$MENU_DESC" ${MW} ${MH} ${MENU_H})

    export CHOICE=($("${DIALOG[@]}" "${MENU_ARRAY[@]}" 2>&1 >/dev/tty))

}