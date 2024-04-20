#!/bin/bash

set -e

if [[ "${1}" == "" ]]; then
	echo "Please provide path to an image as your first argument"
	exit 1
fi

if [[ "${2}" == "" ]]; then
	echo "Please provide your DPI as your second argument"
	exit 2
fi

IMAGE="${1}"
DPI=${2}

filename=$(basename -- "${IMAGE}")
extension="${filename##*.}"

NEW_IMAGE="${IMAGE/.$extension/.png}"

if [ -f "${IMAGE}" ]; then
	convert -units PixelsPerInch "${IMAGE}" -density ${DPI} "${NEW_IMAGE}"
	rm "${IMAGE}"
else 
	echo "${IMAGE} does not exist"
	exit 3
fi