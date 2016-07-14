#!/bin/bash
# name: verifylto
# description: verifylto creates a text document with a list of checksums that are generated after a readback. This is to ensure that all files transferred over correctly.
HIDDEN_FILES=""
TAPE_MOUNT_POINT="/Volumes"
TAPE_SERIAL_REGEX="[A-Z0-9]\{6\}"
LTO_LOGS="$HOME/Documents/lto_indexes"
SCRIPTDIR=$(dirname "${0}")
TAPE_EJECT="Y"

_usage(){
    echo "verifylto"
    echo "Usage:"
    echo "    -t tape serial"
    echo "    -e [ N|Y ] (state yes or no to ejecting the tape after write, default is yes)"
    exit 1
}

. "${SCRIPTDIR}/mmfunctions" || { echo "Missing '${SCRIPTDIR}/mmfunctions'. Exiting." ; exit 1 ;};

# command-line options
OPTIND=1
while getopts ":t:e" opt ; do
    case "${opt}" in
        t) TAPE_SERIAL="${OPTARG}" ;;
        e) TAPE_EJECT="${OPTARG}" ;;
        *) echo "bad option -${OPTARG}" ; _usage ;;
        :) echo "Option -${OPTARG} requires an argument" ; exit 1 ;;
    esac
done
shift $(( ${OPTIND} - 1 ))


SOURCE_DIR="${1}"
if [[ ! $(echo "${TAPE_SERIAL}" | grep "${TAPE_SERIAL_REGEX}") ]] ; then
    echo "${TAPE_SERIAL}" is not a capital letter followed by a 5 digit number
    _usage
    exit 1
fi

TAPE_PATH="${TAPE_MOUNT_POINT}/${TAPE_SERIAL}"

_checkdir "${TAPE_PATH}"

VERIFYTIME=$(_get_iso8601_c)
READBACKDIR="${LTO_LOGS}/readback_checksums"
_mkdir2  "${READBACKDIR}"
find "${TAPE_PATH}" -type f ! -name .DS_Store -exec md5deep -rel "{}" >> "${READBACKDIR}/${TAPE_SERIAL}_ReadBack_checksum_${VERIFYTIME}.md5" \;

case "${TAPE_EJECT}" in
    y|Y) umount "${TAPE_PATH}" ;;
    *) echo "Done verifying but not ejecting ${TAPE_SERIAL}." ;;
esac