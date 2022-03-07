#!/bin/bash

# Get Available drives
SELECT_DRIVE() {
  
  PS3="Please select a drive ($1): "
  DRIVES="$(grep -E "/dev/(sd|hd)[a-z]+" /proc/mounts | awk '{print $1}') exit"
  select DRIVE in $DRIVES
  do  

    [ $DRIVE == "exit" ] && echo "Exiting..." && exit 0
    
    read -p "Are you sure? [y/N]: " ANSWER

    case $ANSWER in
      y|Y)
        [ ! -z "$DRIVE" ] && echo $DRIVE
        exit
        ;;
      *)  
        SELECT_DRIVE $1
        ;;
    esac
  done
}

SELECT_DRIVE