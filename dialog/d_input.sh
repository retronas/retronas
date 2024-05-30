_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}
MENU_NAME=$1
CLEAR

### this needs to be smarter oneday
case $MENU_NAME in
    set-etherdfs-nic)
        OLDVALUE=${OLDETHERDFSIF}
        DATASET=($(ip link show | awk '/^[0-9]/{gsub(/:/,"");print $2}'))
        PATTERN="retronas_etherdfs_interface:"
        ;;
    set-top-level-dir)
        OLDVALUE="${OLDRNPATH}"
        DATASET=()
        PATTERN="retronas_path:"
        ;;
    update-user)
        OLDVALUE="${OLDRNUSER}"
        DATASET=($(awk -F':' '{print $1}' /etc/passwd  | paste -d" " -s))
        PATTERN="retronas_user:"
        ;;
    update-group)
        OLDVALUE="${OLDRNGROUP}"
        DATASET=($(awk -F':' '{print $1}' /etc/group  | paste -d" " -s))
        PATTERN="retronas_group:"
        ;;
    set-retronas-net-retro-nic)
        OLDVALUE=${OLDRETROIF}
        DATASET=($(ip link show | awk '/^[0-9]/{gsub(/:/,"");print $2}'))
        PATTERN="retronas_net_retro_interface:"
        ;;
    set-retronas-net-modern-nic)
        OLDVALUE=${OLDMODERNIF}
        DATASET=($(ip link show | awk '/^[0-9]/{gsub(/:/,"");print $2}'))
        PATTERN="retronas_net_modern_interface:"
        ;;
    *)
        PAUSE
        EXIT_CANCEL
        ;;
esac

rn_input() {
    local MENU_NAME="${1}"
    READ_MENU_TDESC "${MENU_NAME}"
    DLG_INPUTBOX "${MENU_TNAME}" "${MENU_BLURB}" "${OLDVALUE}"

    export NEWVALUE="${CHOICE}"

    if [ ! -z $NEWVALUE ]
    then
        COMPARE_VALUES "${NEWVALUE}" "${OLDVALUE}"
        if [ $CONFIRM -eq 1 ] 
        then
            rn_input_confirm ${NEWVALUE}
        else
            rn_input $MENU_NAME
        fi
    fi
}


rn_input_confirm() {
    unset CHOICE
    local MENU_PARENT=${MENU_NAME}
    local MENU_NAME="${MENU_NAME}-confirm"
    READ_MENU_TDESC "${MENU_NAME}"
    DLG_YN "${MENU_TNAME}" "${MENU_BLURB}"

    case ${CHOICE} in
        0)
            # this is crap, fix it later - mostly just for directories atm
            [ ${#DATASET[@]} -eq 0 ] && DATASET=($(ls -lad "${NEWVALUE}" 2>/dev/null | awk '{print $9}'))

            echo ${DATASET[*]} | grep -qF ${NEWVALUE}
            if  [ $? -eq 0 ]
            then
                CLEAR
                source $_CONFIG
                sed -i "/${PATTERN}/d" "${ANCFG}"
                echo "${PATTERN} \"${NEWVALUE}\"" >> "${ANCFG}"
                source $_CONFIG
                EXIT_OK
            else
                CLEAR
                RN_LOG "${NEWVALUE} is not a valid choice, please confirm your choice"
                PAUSE
                rn_input $MENU_PARENT
            fi
            ;;
        *)
            exit ${CHOICE}
            ;;
    esac
}

rn_input $MENU_NAME