#!/bin/bash


_CONFIG=/opt/retronas/dialog/retronas.cfg
source $_CONFIG
source ${DIDIR}/common.sh
cd ${DIDIR}

DROP_ROOT

rn_gog_chooser() {
  source $_CONFIG

  local MENU_ARRAY=(
    01 "Exit to previous menu"
    02 "Configure my GOG credentials"
    03 "Change my GOG Operating System setting"
    04 "Synchronise my games list"
    05 "Download/update a single game"
    06 "Download/update all games currently in my games list"
    07 "FULL - Synchronise games list & download/update all games"
  )

  local MENU_BLURB="Current Operating System: ${OLDGOGOS} \
  \n
  \nPlease choose a task"

  DLG_MENU "gogrepo configure OS" $MENU_ARRAY 10 "${MENU_BLURB}"

  while true
  do
    source $_CONFIG
    case ${CHOICE} in
    02)
      # login
      CLEAR
      ${SUCOMMAND} ${RNDIR}/scripts/gogrepo_login.sh
      PAUSE
      ;;
    03)
      # OS
      rn_gog_setos
      ;;
    04)
      # sync games list
      CLEAR
      ${SUCOMMAND} ${RNDIR}/scripts/gogrepo_update.sh -skipknown -os ${OLDGOGOS}
      PAUSE
      ;;
    05)
      # download 1 game
      rn_gog_gameslist
      rn_gog_game
      GOGGAME=$( cat ${TDIR}/rn_gog_game )
      CLEAR
      ${SUCOMMAND} ${RNDIR}/scripts/gogrepo_update.sh -os ${OLDGOGOS} -id ${GOGGAME}
      ${SUCOMMAND} ${RNDIR}/scripts/gogrepo_download.sh -id ${GOGGAME}
      PAUSE
      ;;
    06)
      # download all games
      CLEAR
      ${SUCOMMAND} ${RNDIR}/scripts/gogrepo_download.sh
      PAUSE
      ;;
    07)
      # sync and download
      CLEAR
      ${SUCOMMAND} ${RNDIR}/scripts/gogrepo_update.sh -os ${GOGOS}
      ${SUCOMMAND} ${RNDIR}/scripts/gogrepo_download.sh
      PAUSE
      ;;
    *)
      exit 1
      ;;
    esac
  done

}

rn_gog_setos() {
  source $_CONFIG

  local MENU_ARRAY=(
    01 "Exit to previous menu"
    02 "Windows only"
    03 "Mac only"
    04 "Linux only"
    05 "Windows & Mac"
    06 "Windows & Linux"
    07 "Mac & Linux"
    08 "ALL Operating Systems"
  )

  local MENU_BLURB="Current Operating Systems: ${OLDGOGOS} \
  \n
  \nPlease set the Operating System(s) you would like to download GOG games for."

  DLG_MENU "gogrepo configure OS" $MENU_ARRAY 10 "${MENU_BLURB}"

  case ${CHOICE} in
    02)
      sed -i '/retronas_gog_os:/d' "${ANCFG}"
      echo 'retronas_gog_os: "windows"' >>"${ANCFG}"
      ;;
    03)
      sed -i '/retronas_gog_os:/d' "${ANCFG}"
      echo 'retronas_gog_os: "mac"' >>"${ANCFG}"
      ;;
    04)
      sed -i '/retronas_gog_os:/d' "${ANCFG}"
      echo 'retronas_gog_os: "linux"' >>"${ANCFG}"
      ;;
    05)
      sed -i '/retronas_gog_os:/d' "${ANCFG}"
      echo 'retronas_gog_os: "windows mac"' >>"${ANCFG}"
      ;;
    06)
      sed -i '/retronas_gog_os:/d' "${ANCFG}"
      echo 'retronas_gog_os: "windows linux"' >>"${ANCFG}"
      ;;
    07)
      sed -i '/retronas_gog_os:/d' "${ANCFG}"
      echo 'retronas_gog_os: "mac linux"' >>"${ANCFG}"
      ;;
    08)
      sed -i '/retronas_gog_os:/d' "${ANCFG}"
      echo 'retronas_gog_os: "windows mac linux"' >>"${ANCFG}"
      ;;
    *)
      exit 0
      ;;
  esac
}

rn_gog_gameslist() {
  rm ${TDIR}/rn_gog_gameslist 2>/dev/null
  RNUDIR=$( getent passwd ${OLDRNUSER} | awk -F ':' '{print $6}' )
  grep \'title\'\: ${RNUDIR}/.gogrepo/gog-manifest.dat | awk -F \' '{print $4}' | sort | while read RN_GOG_ID
  do
    echo -en "${RN_GOG_ID} . " >>${TDIR}/rn_gog_gameslist
  done
}

rn_gog_game() {

  local MENU_ARRAY=(
    $(cat ${TDIR}/rn_gog_gameslist)
  )

  local MENU_BLURB="Please choose a game \
  \n
  \nIf your game has not appeared, please synchronise your games list"

  DLG_MENU "gogrepo game chooser" $MENU_ARRAY 10 "${MENU_BLURB}"

}


CLEAR
rn_gog_chooser