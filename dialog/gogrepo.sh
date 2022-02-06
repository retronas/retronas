#!/bin/bash

clear
source /opt/retronas/dialog/retronas.cfg
cd ${DIDIR}

## If this is run as root, switch to our RetroNAS user
## Manifests and cookies stored in ~/.gogrepo
if [ "${USER}" == "root" ]
then
  SUCOMMAND="sudo -u ${OLDRNUSER}"
else
  SUCOMMAND=""
fi


rn_gog_chooser() {
source /opt/retronas/dialog/retronas.cfg
dialog \
  --backtitle "RetroNAS" \
  --title "gogrepo chooser" \
  --clear \
  --menu "Current OS: ${OLDGOGOS} \
  \n
  \nPlease choose a task" ${MG} 10 \
  "01" "Exit to previous menu" \
  "02" "Configure my GOG credentials" \
  "03" "Change my GOG Operating System setting" \
  "04" "Synchronise my games list" \
  "05" "Download/update a single game" \
  "06" "Download/update all games currently in my games list" \
  "07" "FULL - Synchronise games list & download/update all games" \
  2> ${TDIR}/rn_gog_chooser
}

rn_gog_setos() {
source /opt/retronas/dialog/retronas.cfg
dialog \
  --backtitle "RetroNAS" \
  --title "gogrepo configure OS" \
  --clear \
  --menu "Current Operating Systems: ${OLDGOGOS} \
  \n
  \nPlease set the Operating System(s) you would like to download GOG games for." ${MG} 10 \
  "01" "Exit to previous menu" \
  "02" "Windows only" \
  "03" "Mac only" \
  "04" "Linux only" \
  "05" "Windows & Mac" \
  "06" "Windows & Linux" \
  "07" "Mac & Linux" \
  "08" "ALL Operating Systems" \
  2> ${TDIR}/rn_gog_setos
NEWGOGOS=$( cat ${TDIR}/rn_gog_setos )
case ${NEWGOGOS} in
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
RNUDIR=$( getent passwd | grep ^${OLDRNUSER}\: | awk -F ':' '{print $6}' )
grep \'title\'\: ${RNUDIR}/.gogrepo/gog-manifest.dat | awk -F \' '{print $4}' | sort | while read RN_GOG_ID
do
  echo -en "${RN_GOG_ID} . " >>${TDIR}/rn_gog_gameslist
done
}

rn_gog_game() {
dialog \
  --backtitle "RetroNAS" \
  --title "gogrepo game chooser" \
  --clear \
  --menu "Please choose a game \
  \n
  \nIf your game has not appeared, please synchronise your games list" ${MG} 10 \
  $(cat ${TDIR}/rn_gog_gameslist) 2> ${TDIR}/rn_gog_game
}

while true
do
  source /opt/retronas/dialog/retronas.cfg
  rn_gog_chooser
  CHOICE=$( cat ${TDIR}/rn_gog_chooser )
  PAUSEMSG='Press [Enter] to continue...'
  case ${CHOICE} in
  02)
    # login
    clear
    ${SUCOMMAND} ${RNDIR}/scripts/gogrepo_login.sh
    echo "${PAUSEMSG}"
    read -s
    ;;
  03)
    # OS
    rn_gog_setos
    ;;
  04)
    # sync games list
    clear
    ${SUCOMMAND} ${RNDIR}/scripts/gogrepo_update.sh -skipmissing -os ${OLDGOGOS}
    echo "${PAUSEMSG}"
    read -s
    ;;
  05)
    # download 1 game
    rn_gog_gameslist
    rn_gog_game
    GOGGAME=$( cat ${TDIR}/rn_gog_game )
    clear
    ${SUCOMMAND} ${RNDIR}/scripts/gogrepo_update.sh -os ${OLDGOGOS} -id ${GOGGAME}
    ${SUCOMMAND} ${RNDIR}/scripts/gogrepo_download.sh -id ${GOGGAME}
    echo "${PAUSEMSG}"
    read -s
    ;;
  06)
    # download all games
    clear
    ${SUCOMMAND} ${RNDIR}/scripts/gogrepo_download.sh
    echo "${PAUSEMSG}"
    read -s
    ;;
  07)
    # sync and download
    clear
    ${SUCOMMAND} ${RNDIR}/scripts/gogrepo_update.sh -os ${GOGOS}
    ${SUCOMMAND} ${RNDIR}/scripts/gogrepo_download.sh
    echo "${PAUSEMSG}"
    read -s
    ;;
  *)
    exit 1
    ;;
  esac
done
