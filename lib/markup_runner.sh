#!/bin/bash
set -u

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
PBIN=/usr/bin/pandoc
LBIN=/usr/bin/lynx

INPUT=${1}

if [ ! -f ${RNDOC}/${INPUT} ]
then
    #echo "Documentation has not been installed, will display README.md"
    INPUT="${RNDIR}/README.md"
else
    INPUT="${RNDOC}/${INPUT}"
fi

${PBIN} "${INPUT}" | ${LBIN} -stdin