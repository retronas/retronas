#!/bin/bash

clear

source /opt/retronas/dialog/retronas.cfg
cd ${DIDIR}

rn_get_dirs() {
cd "${OLDRNPATH}"
find . -maxdepth 1 -type d | sed 's#^\./##g' | grep -v ^\.$ | sort | while read PATHITEM
do
  echo "${PATHITEM}" "${PATHITEM}" >> ${TDIR}/rn_get_dirs
  COUNT=$((${COUNT}+1))
done

cat ${TDIR}/rn_get_dirs
}

rn_fix_perms() {
cd ${DIDIR}
dialog \
  --backtitle "RetroNAS" \
  --title "RetroNAS Fix Permissions" \
  --clear \
  --menu "Please choose a directory below ${OLDRNPATH} to fix. \
  \n
  \nThis will reset all the file ownership to the user \"${OLDRNUSER}\" \
  \n
  \nPlease be careful, as this is irreversible.  If unsure, exit now." \
  ${MG} 5 \
  "1" "Exit to main menu" \
  $( cat  ${TDIR}/rn_get_dirs ) 2>${TDIR}/rn_fix_perms
}

rn_get_dirs

rn_fix_perms
CHOICE=$( cat ${TDIR}/rn_fix_perms )
case ${CHOICE} in
  1)
    exit 1
    ;;
  *)
    clear
    chown -Rc ${OLDRNUSER}:${OLDRNUSER} "${OLDRNPATH}/${CHOICE}"
    chmod -Rc u+rwX "${OLDRNPATH}/${CHOICE}"
    ;;
esac
