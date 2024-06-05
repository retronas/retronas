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
    set-retronas_net_wifi_countrycode)
        OLDVALUE=${OLDWIFICC}
        DATASET=(AU NZ US)
        PATTERN="retronas_net_wifi_countrycode:"
        ;;
    set-retronas-net-retro-dhcprange)
        OLDVALUE=${OLDRETRODHCP}
        DATASET=()
        PATTERN="retronas_net_retro_dhcprange:"
        ;;
    set-retronas-net-retro-router)
        OLDVALUE=${OLDRETROROUTER}
        DATASET=()
        PATTERN="retronas_net_retro_router:"
        ;;
    set-retronas-net-retro-ntp)
        OLDVALUE=${OLDRETRONTP}
        DATASET=()
        PATTERN="retronas_net_retro_ntp:"
        ;;
    set-retronas-net-upstream-dns1)
        OLDVALUE=${OLDUPDNS1}
        DATASET=()
        PATTERN="retronas_net_upstream_dns1:"
        ;;
    set-retronas-net-upstream-dns2)
        OLDVALUE=${OLDUPDNS2}
        DATASET=()
        PATTERN="retronas_net_upstream_dns2:"
        ;;
    set-retronas-net-wifi-interface)
        OLDVALUE=${OLDWIFIINT}
        DATASET=()
        PATTERN="retronas_net_wifi_interface:"
        ;;
    set-retronas-net-wifi-ssid)
        OLDVALUE=${OLDWIFISSID}
        DATASET=()
        PATTERN="retronas_net_wifi_ssid:"
        ;;
    set-retronas-net-wifi-channel)
        OLDVALUE=${OLDWIFICHANNEL}
        DATASET=()
        PATTERN="retronas_net_wifi_channel:"
        ;;
    set-retronas-net-wifi-hwmode)
        OLDVALUE=${OLDWIFIHWMODE}
        DATASET=()
        PATTERN="retronas_net_wifi_hwmode:"
        ;;
    set-retronas-net-retro-ip)
        OLDVALUE=${OLDRETROIP}
        DATASET=()
        PATTERN="retronas_net_retro_ip:"
        ;;
    set-retronas-net-retro-subnet)
        OLDVALUE=${OLDRETROSUBNET}
        DATASET=()
        PATTERN="retronas_net_retro_subnet:"
        ;;
    set-retronas-net-wifi-ip)
        OLDVALUE=${OLDWIFIIP}
        DATASET=()
        PATTERN="retronas_net_wifi_ip:"
        ;;
    set-retronas-net-wifi-subnet)
        OLDVALUE=${OLDWIFISUBNET}
        DATASET=()
        PATTERN="retronas_net_wifi_subnet:"
        ;;
    set-retronas-net-wifi-dhcprange)
        OLDVALUE=${OLDWIFIDHCP}
        DATASET=()
        PATTERN="retronas_net_wifi_dhcprange:"
        ;;
    set-retronas-net-wifi-router)
        OLDVALUE=${OLDWIFIROUTER}
        DATASET=()
        PATTERN="retronas_net_wifi_router:"
        ;;
    set-retronas-net-wifi-ntp)
        OLDVALUE=${OLDWIFINTP}
        DATASET=()
        PATTERN="retronas_net_wifi_ntp:"
        ;;
    set-retronas-net-wifi-dns)
        OLDVALUE=${OLDWIFIDNS}
        DATASET=()
        PATTERN="retronas_net_wifi_dns:"
        ;;
    set-retronas-net-retro-dns)
        OLDVALUE=${OLDRETRODNS}
        DATASET=()
        PATTERN="retronas_net_retro_dns:"
        ;;
    *)
        echo "Menu not supported"
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
            if [ $? -eq 0 ] || [ ${#DATASET[@]} -eq 0 ]
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