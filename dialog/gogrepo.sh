#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}

## Manifests and cookies stored in ~/.gogrepo
CLEAR

rn_gog_chooser() {

  local MENU_NAME=gogrepo
  READ_MENU_JSON "${MENU_NAME}"
  READ_MENU_TDESC "${MENU_NAME}"
  DLG_MENUJ "${MENU_TNAME}" 10 "${MENU_BLURB}"
  
  while true
  do
    source $_CONFIG
    
    case ${CHOICE} in
    01)
      EXIT_OK
      ;;
    02)
      READ_MENU_COMMAND ${MENU_NAME} ${CHOICE} 
      ;;
    03)
      # auth menu
      rn_gog_auth
      ;;
    04)
      # OS
      rn_gog_setos
      ;;
    05)
      # LANG
      rn_gog_setlang
      ;;
    06)
      # sync games list
      CLEAR
      DROP_ROOT ${SCDIR}/gogrepo_update.sh -skipknown -os ${OLDGOGOS} -lang ${OLDGOGLANG}
      PAUSE
      ;;
    07)
      # download 1 game
      rn_gog_gameslist
      rn_gog_game
      if [ $? -eq 0 ]
      then
        GOGGAME=$( cat ${TDIR}/rn_gog_game )
        CLEAR
        DROP_ROOT ${SCDIR}/gogrepo_update.sh -os ${OLDGOGOS} -id ${GOGGAME} -lang ${OLDGOGLANG}
        DROP_ROOT ${SCDIR}/gogrepo_download.sh -id ${GOGGAME}
        PAUSE
      fi
      ;;
    08)
      # download all games
      CLEAR
      DROP_ROOT ${SCDIR}/gogrepo_download.sh
      PAUSE
      ;;
    09)
      # sync and download
      CLEAR
      DROP_ROOT ${SCDIR}/gogrepo_update.sh -os ${OLDGOGOS} -lang ${OLDGOGLANG}
      DROP_ROOT ${SCDIR}/gogrepo_download.sh
      PAUSE
      ;;
    *)
      EXIT_CANCEL
      ;;
    esac
    unset CHOICE
  done

}


rn_gog_setlang() {
  source $_CONFIG

  local MENU_NAME=gogrepo
  READ_MENU_JSON "${MENU_NAME}" "${MENU_NAME}-setuplang"
  READ_MENU_TDESC "${MENU_NAME}" "${MENU_NAME}-setuplang"
  DLG_MENUJ "${MENU_TNAME}" 10 "${MENU_BLURB}"


  case ${CHOICE} in
    01)
      EXIT_OK
      ;;
    ${CHOICE} )
      NEWLANG="${CHOICE}"
      ;;
    *)
      EXIT_CANCEL
      ;;
    esac

    sed -i '/retronas_gog_lang:/d' "${ANCFG}"
    echo "retronas_gog_lang: \"${NEWLANG}\"" >> "${ANCFG}"

}

rn_gog_auth() {
  source $_CONFIG

  local MENU_NAME=gogrepo
  READ_MENU_JSON "${MENU_NAME}" "${MENU_NAME}-auth"
  READ_MENU_TDESC "${MENU_NAME}" "${MENU_NAME}-auth"
  DLG_MENUJ "${MENU_TNAME}" 10 "${MENU_BLURB}"

  case ${CHOICE} in
    01)
      EXIT_OK
      ;;
    02)
      # login
      CLEAR
      DROP_ROOT ${SCDIR}/gogrepo_login.sh
      PAUSE
      ;;
    03)
      # import cookies
      CLEAR
      DROP_ROOT ${SCDIR}/gogrepo_import-cookies.sh
      PAUSE
      ;;
    *)
      EXIT_CANCEL
      ;;
  esac

}

rn_gog_setos() {
  source $_CONFIG

  local MENU_NAME=gogrepo
  READ_MENU_JSON "${MENU_NAME}" "${MENU_NAME}-setupos"
  READ_MENU_TDESC "${MENU_NAME}" "${MENU_NAME}-setupos"
  DLG_MENUJ "${MENU_TNAME}" 10 "${MENU_BLURB}"

  case ${CHOICE} in
    01)
      EXIT_OK
      ;;
    02)
      NEWOS="windows"
      ;;
    03)
      NEWOS="mac"
      ;;
    04)
      NEWOS="linux"
      ;;
    05)
      NEWOS="windows mac"
      ;;
    06)
      NEWOS="windows linux"
      ;;
    07)
      NEWOS="mac linux"
      ;;
    08)
      NEWOS="windows mac linux"
      ;;
    *)
      EXIT_CANCEL
      ;;
    esac

    sed -i '/retronas_gog_os:/d' "${ANCFG}"
    echo "retronas_gog_os: \"${NEWOS}\"" >> "${ANCFG}"
  
}

rn_gog_gameslist() {
  rm ${TDIR}/rn_gog_gameslist 2>/dev/null
  RNUDIR=$( getent passwd | grep ^${OLDRNUSER}\: | awk -F ':' '{print $6}' )
  if [ ! -f ${RNUDIR}/.gogrepo/gog-manifest.dat ]
  then
    echo "GOG Manifest not found, you'll need to login/sync first"
    PAUSE
    echo 1
  else
    grep \'title\'\: ${RNUDIR}/.gogrepo/gog-manifest.dat | awk -F \' '{print $4}' | sort | while read RN_GOG_ID
    do
      echo -en "${RN_GOG_ID} . " >>${TDIR}/rn_gog_gameslist
    done
  fi
}

rn_gog_game() {
  local MENU_NAME=gogrepo
  READ_MENU_JSON "${MENU_NAME}" "${MENU_NAME}-gamechooser"
  READ_MENU_TDESC "${MENU_NAME}" "${MENU_NAME}-gamechooser"

  MENU_ARRAY=$(cat ${TDIR}/rn_gog_gameslist)

  dialog \
    --backtitle "${MENU_TNAME}" \
    --title "${MENU_TNAME}" \
    --clear \
    --menu "${MENU_BLURB}" ${MW} ${MH} 10 \
    ${MENU_ARRAY[@]} \
    2> ${TDIR}/rn_gog_game

}

rn_gog_chooser
