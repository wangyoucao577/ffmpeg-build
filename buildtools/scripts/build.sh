#!/bin/bash -ex

echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then

    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
fi
CURRENT_DIR_PATH=$(dirname $(realpath $0))

source ${CURRENT_DIR_PATH}/options.sh

# build in order
cd ${CURRENT_DIR_PATH}

if [[ ${NVIDIA_GPU_AVAILABLE} == "true" ]]; then
./build-nv-codec-headers.sh # useful for ffmpeg with nvidia gpu only
fi

./build-x264.sh
./build-x265.sh
./build-svtav1.sh
./build-vmaf.sh
./build-sdl.sh
./build-ffmpeg.sh "$@"

cd - 

