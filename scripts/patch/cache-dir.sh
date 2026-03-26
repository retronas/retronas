#!/bin/sh

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG

[ ! -d $ACACHEDIR ] && mkdir -p $ACACHEDIR
