#!/bin/bash

set -e
#set -x

#IFS=$'\n'
FMT_DIR=/data/retronas/config/formats
IMG_DIR=/data/retronas/images
MOUNT=0

_usage() {
    echo "BLAH"
    exit 1
}

error() {
    echo "ERROR: $1"
}

log() {
    echo "LOG: $1"
}

[ ! -d ${FMT_DIR} ] && exit 1

while getopts "v:n:p:m" OPTS; do
    case "${OPTS}" in
        m)
            MOUNT=1
            ;;
        n)
            NAME=${OPTARG}
            ;;
        p)
            PROFILE=${OPTARG}
            ;;
        v)
            VOLUME=${OPTARG}
            ;;
        *)
            _usage
            ;;
    esac
done

REQFAIL=0
[ -z "${PROFILE}" ] && error "Profile is required" && REQFAIL=1
[ ! -f "${FMT_DIR}/${PROFILE}" ] && error "Profile $PROFILE not found" && REQFAIL=1
[ -z "${NAME}" ] && error "Name is required" && REQFAIL=1
[ $REQFAIL -eq 1 ] && exit 1

[ ! -d "${IMG_DIR}" ] && mkdir -p "${IMG_DIR}"
### this should come as input along with VOLUME, NAME and MOUNT

. "${FMT_DIR}/${PROFILE}"
OUTNAME="${IMG_DIR}/${NAME}${EXT}"

CLI_OPTS="of=${OUTNAME}"
[ ! -z "$SEEK" ] && CLI_OPTS+=" seek=$SEEK"
[ ! -z "$BYTESIZE" ] && CLI_OPTS+=" bs=$BYTESIZE"

#create
if [ ! -f ${OUTNAME} ]
then

    dd if=/dev/zero $CLI_OPTS count=$((${SIDES}*${TRACKS}*${SECTORS}))
    sync

    [ ! -f "${OUTNAME}" ] && error "Failed to create file ${OUTNAME}" && exit 1
    #format
    if [ ! -z $FS ]
    then
        FCLI_OPTS=""
        case $FS in
            FAT12)
                [ ! -z "$VOLUME" ] && FCLI_OPTS+=" -n ${VOLUME}"
                mkfs.vfat -F12 -I -v $FCLI_OPTS "${OUTNAME}"
                ;;
            FAT32)
                mkfs.vfat -F32 -I -v "${OUTNAME}"
                ;;
            *)
                error "Unsupported: $FS"
        esac
    else
        error "FS not set in profile, will not format"
    fi
    sync

else
    error "File exists: ${OUTNAME}"
fi


# mount
if [ $MOUNT -eq 1 ]
then
    log "I would mount an image here"
fi