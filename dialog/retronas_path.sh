#!/bin/bash

clear
source /opt/retronas/dialog/retronas.cfg
cd ${DIDIR}

rn_retronas_path() {
dialog \
  --backtitle "RetroNAS" \
  --clear \
  --title "Please type in the RetroNAS top level directory" \
  --dselect "${OLDRNPATH}" ${MG} 2>${TDIR}/rn_retronas_path
  # Strip the trailing slash
  cat ${TDIR}/rn_retronas_path | sed 's#/$##g' > ${TDIR}/rn_retronas_path2
  mv ${TDIR}/rn_retronas_path2 ${TDIR}/rn_retronas_path
}

rn_retronas_path_confirm() {
NEWRNPATH=$( cat ${TDIR}/rn_retronas_path )
dialog \
  --clear \
  --title "Confirm" \
  --defaultno \
  --yesno "Do you want to save this setting? \
  \nNewRetroNAS top level directory: \"${NEWRNPATH}\" " ${MG}
}

echo "${OLDRNPATH}" > ${TDIR}/rn_retronas_path

# Show the ugly path chooser
rn_retronas_path

# Confirm the input because the path chooser sucks
rn_retronas_path_confirm
CHOICE="$?"

case ${CHOICE} in
  0)
    # Yes, change the value
    # Delete the old value
    sed -i '/retronas_path:/d' "${ANCFG}"
    # Add the new value and re-source
    echo "retronas_path: \"${NEWRNPATH}\"" >> "${ANCFG}"
    source /opt/retronas/dialog/retronas.cfg
    exit 0
    ;;
  *)
    # No, the path chooser sucks probably, so just bail
    exit ${CHOICE}
    ;;
esac
