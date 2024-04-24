#!/bin/bash

# Script to properly scale generated page_#.tif files
# to your desired DPI.

#Requires ImageMagick

#Printer DPI, same as in filmless_processing.pde
if [[ "${1}" == "" ]]; then
	echo "Please provide your DPI as your first argument"
	exit 1
fi
DPI=${1}
#Location of generated pages
PAGE_FILES="./filmless_processing/data/page_*.tif"

echo "Changing exported page files to ${DPI}dpi..."

for f in $PAGE_FILES
do
	name=$(basename "$f" .tif)
	echo "Converting ${f} to ./filmless_processing/data/${name}.png @ ${DPI}dpi..."
	convert $f -units PixelsPerInch -density $DPI "./filmless_processing/data/${name}.png"
done