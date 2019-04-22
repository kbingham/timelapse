#!/bin/bash

NOW=`date --iso-8601=seconds`
OUT=$NOW

FNAME=frame
DEVICE=/dev/video0
PROGRESSREPORT="! progressreport"

POSITIONAL=()
while [[ $# -gt 0 ]]
do
case $1 in
    -x)
        set -x;
        shift;
        ;;
    -q)
        QUIET=-q; shift;
	PROGRESSREPORT=
        ;;
    -v|--verbose)
        VERBOSE=-v; shift;
        ;;
    *)  # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

DEVICE=${1:-$DEVICE}

JPEGNAME="$OUT/$FNAME%06d.jpg"

mkdir -p $OUT

gst-launch-1.0 \
	$QUIET $VERBOSE \
	v4l2src device="$DEVICE" \
	! image/jpeg \
	! queue \
	! videorate \
	! image/jpeg,framerate=1/1 $PROGRESSREPORT \
	! multifilesink location="$JPEGNAME"

exit
