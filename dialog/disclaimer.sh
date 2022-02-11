#!/bin/bash

_CONFIG=/opt/retronas/dialog/retronas.cfg
source $_CONFIG

# User has already agreed, thanks all
[ -f $AGREEMENT ] && exit 0
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
  "AGREE")
    touch $AGREEMENT
    exit 0
    ;;
  *)
    exit 1
esac