#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh


# Get Available branches
SELECT_BRANCH() {
  
    cd /opt/retronas

    # remove deleted remote branches from output
    git fetch --prune origin &> /dev/null

    PS3="Please select a branch ($OLDRNBRANCH): "
    BRANCHES="$(git branch --remotes | awk -F'/' '!/HEAD/{print $2}' ) exit"
    select BRANCH in $BRANCHES
    do  

    [ $BRANCH == "exit" ] && echo "Exiting..." && exit 0

    read -p "Are you sure? [y/N]: " ANSWER

    case $ANSWER in
        y|Y)
        if [ ! -z "$BRANCH" ]
        then
            git clean -d -f
            git reset --hard
            git checkout $BRANCH 1>/dev/null
            echo "Changed branched to $BRANCH, please restart RetroNAS (press CTRL-C key combination)"
            PAUSE
        fi
        exit
        ;;
        *)  
        SELECT_BRANCH $OLDRNBRANCH
        ;;
    esac
    done
}
DROP_ROOT
SELECT_BRANCH