#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}

## Manifests and cookies stored in ~/.gogrepo
CLEAR

# dumb workaround
chmod 755 ${SCDIR}


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
      rn_gog_chooser
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
      rn_gog_game
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
      rn_gog_chooser
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
      rn_gog_chooser
      ;;
    ${CHOICE} )
      NEWLANG="${CHOICE}"
      sed -i '/retronas_gog_lang:/d' "${ANCFG}"
      echo "retronas_gog_lang: \"${NEWLANG}\"" >> "${ANCFG}"
      ;;
    *)
      rn_gog_chooser
      ;;
    esac

    rn_gog_chooser

}

rn_gog_auth() {
  source $_CONFIG

  local MENU_NAME=gogrepo
  READ_MENU_JSON "${MENU_NAME}" "${MENU_NAME}-auth"
  READ_MENU_TDESC "${MENU_NAME}" "${MENU_NAME}-auth"
  DLG_MENUJ "${MENU_TNAME}" 10 "${MENU_BLURB}"

  case ${CHOICE} in
    02)
      # login
      CLEAR
      DROP_ROOT ${SCDIR}/gogrepo_login.sh
      PAUSE
      ;;
    03)
      # import cookies
      CLEAR
      bash ${SCDIR}/gogrepo_import-cookies.sh
      PAUSE
      ;;
    *)
      rn_gog_chooser
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
      rn_gog_chooser
      ;;
    esac

    if [ ! -z $NEWOS ]; then
      sed -i '/retronas_gog_os:/d' "${ANCFG}"
      echo "retronas_gog_os: \"${NEWOS}\"" >> "${ANCFG}"
    fi

    rn_gog_chooser
  
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
      echo "${RN_GOG_ID}" >>${TDIR}/rn_gog_gameslist
    done
  fi
}

rn_gog_game() {
  local MENU_NAME=gogrepo
  READ_MENU_JSON "${MENU_NAME}" "${MENU_NAME}-gamechooser"
  READ_MENU_TDESC "${MENU_NAME}" "${MENU_NAME}-gamechooser"

  declare -a MENU_ARRAY
  mapfile -t PIECES < ${TDIR}/rn_gog_gameslist
  MENU_ARRAY+=("Back" ".")
  for PIECE in ${PIECES[@]}
  do      
    MENU_ARRAY+=($PIECE ".")
  done

  DLG_MENU "${MENU_TNAME}" "${MENU_ARRAY}" 10 "${MENU_BLURB}"

  case ${CHOICE} in
    Back)
      rn_gog_chooser
      ;;
    ${CHOICE})
      echo ${CHOICE} > ${TDIR}/rn_gog_game
      ;;
    *)
      rn_gog_chooser
      ;;
  esac

  unset MENU_ARRAY
}

rn_gog_chooser
