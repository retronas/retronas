#!/bin/bash

clear
_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}

rn_gog_chooser() {
source /opt/retronas/config/retronas.cfg
dialog \
  --backtitle "RetroNAS" \
  --title "litch chooser" \
  --clear \
  --menu "\
  \n
  \nWARNING: This tool is in an alpha state,\nsee https://github.com/eddie3/gogrepo/issues/63
  \n\nPlease choose a task" ${MG} 10 \
  "01" "Back" \
  "02" "Configure my itch.io credentials" \
  "03" "Claim bundle purchases" \
  "04" "Download purchases" \
  "05" "Download(+clean) purchases" \
  2> ${TDIR}/rn_gog_chooser
}

DROP_ROOT

while true
do
  source /opt/retronas/config/retronas.cfg
  rn_gog_chooser
  CHOICE=$( cat ${TDIR}/rn_gog_chooser )
  PAUSEMSG='Press [Enter] to continue...'
  case ${CHOICE} in
    01)
      EXIT_OK
    ;;
  02)
    # login
    CLEAR
    ${SUCOMMAND} ${RNDIR}/scripts/litch_login.sh
    PAUSE
    ;;
  03)
    # claim
    CLEAR
    ${SUCOMMAND} ${RNDIR}/scripts/litch_claim.sh
    PAUSE
    ;;
  04)
    # download
    CLEAR
    ${SUCOMMAND} ${RNDIR}/scripts/litch_download.sh
    PAUSE
    ;;
  05)
    # download+clean
    CLEAR
    ${SUCOMMAND} ${RNDIR}/scripts/litch_download_clean.sh
    PAUSE
    ;;
  *)
    EXIT_CANCEL
    ;;
  esac
done
