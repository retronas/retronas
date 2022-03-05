#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

# MIGRATION
[ ! -d $(dirname $AGREEMENT) ] && mkdir $(dirname $AGREEMENT)
[ -f $OLDAGREEMENT ] && mv $OLDAGREEMENT $AGREEMENT

# User has already agreed, thanks all
if [ -f $AGREEMENT ]
then
  EXIT_OK
fi
clear

## Check our information is available
REQFAIL=0
[ ! -f $RNDIR/SECURITY ] && echo "SECURITY information is missing, please reinstall" REQFAIL=1
[ ! -f $RNDIR/LICENSE ] && echo "LICENSE information was not found" && REQFAIL=1
[ $REQFAIL -ne 0 ] && "Required information could not be found, see previous errors" && exit $REQFAIL

cat $RNDIR/SECURITY
echo -e "\n"
read -p "LICENSE will follow, press Enter"
echo ""
cat $RNDIR/LICENSE
echo ""
read -p "type AGREE to accept the above in use of this project: " INPUT

case $INPUT in
  "agree"|"AGREE")
    touch $AGREEMENT
    EXIT_OK
    ;;
  *)
    EXIT_CANCEL
esac