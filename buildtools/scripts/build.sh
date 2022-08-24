#!/bin/bash -e

# echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then

    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
fi
CURRENT_DIR_PATH=$(dirname $(realpath $0))

source ${CURRENT_DIR_PATH}/options.sh

# build in order

if [[ ${NVIDIA_GPU_AVAILABLE} == "true" ]]; then
${CURRENT_DIR_PATH}/build-nv-codec-headers.sh # useful for ffmpeg with nvidia gpu only
fi


${CURRENT_DIR_PATH}/build-libxml2.sh
${CURRENT_DIR_PATH}/build-freetype.sh
${CURRENT_DIR_PATH}/build-fontconfig.sh
${CURRENT_DIR_PATH}/build-fribidi.sh
${CURRENT_DIR_PATH}/build-harfbuzz.sh
${CURRENT_DIR_PATH}/build-libass.sh
${CURRENT_DIR_PATH}/build-openssl.sh
${CURRENT_DIR_PATH}/build-boringssl.sh
${CURRENT_DIR_PATH}/build-x264.sh
${CURRENT_DIR_PATH}/build-x265.sh
${CURRENT_DIR_PATH}/build-svtav1.sh
${CURRENT_DIR_PATH}/build-aom.sh
${CURRENT_DIR_PATH}/build-opus.sh
${CURRENT_DIR_PATH}/build-fdk-aac.sh
${CURRENT_DIR_PATH}/build-vmaf.sh
${CURRENT_DIR_PATH}/build-sdl.sh
${CURRENT_DIR_PATH}/build-srt.sh
${CURRENT_DIR_PATH}/build-rtmpdump.sh
${CURRENT_DIR_PATH}/build-ffmpeg.sh "$@"


