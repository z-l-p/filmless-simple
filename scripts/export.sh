#!/bin/bash

if [[ "${1}" == "" ]]; then
   echo "Please include path to video file as first argument"
   exit 1
fi


WITH_SOUND=false		#change to false for a silent film

#changes based on printer DPI, this is for 1440
#check the output of the calibration script
AUDIO_RATE=10368

#Either use the script by passing in a path, ie:
#sh export.sh /path/to/my/video.mov
#or hardcode it by changing VIDEO=${1} to VIDEO=/path/to/my/video.mov
VIDEO="${1}"

if [ ! -f "${VIDEO}" ]; then
    echo "Video file ${VIDEO} does not exist, exiting script..."
    exit 2 
fi

# change these to directory where you will store your frames and audio
FRAMES_DIR=./filmless_processing/data/frames/
AUDIO_DIR=./filmless_processing/data/audio/

mkdir -p "$FRAMES_DIR"
mkdir -p "$AUDIO_DIR"

echo "Exporting ${VIDEO}..."


rm -f "${FRAMES_DIR}*.png"
ffmpeg -y -i "${VIDEO}" -f image2 -r 24 -compression_algo raw -pix_fmt rgb24 -crf 0 "${FRAMES_DIR}image-%08d.png"

if [ "$WITH_SOUND" == "true" ]; then
  echo "Exporting audio from ${VIDEO}..."
  ffmpeg -y -i "${VIDEO}" -y -acodec pcm_s16le -ac 1 -ar $AUDIO_RATE "${AUDIO_DIR}audio.wav"
fi
