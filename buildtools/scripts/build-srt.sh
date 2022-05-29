#!/bin/bash -e

PLATFORM_SPECIFIC_PARAMS="-DENABLE_STDCXX_SYNC=ON"

# echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then

    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
elif [[ "$OSTYPE" == "msys"* ]]; then
    # use pthreads on msys
    PLATFORM_SPECIFIC_PARAMS="-DENABLE_STDCXX_SYNC=OFF" 
fi
CURRENT_DIR_PATH=$(dirname $(realpath $0))
PROJECT_ROOT_PATH=${CURRENT_DIR_PATH}/../../


source ${CURRENT_DIR_PATH}/options.sh

# enter build foler
cd ${PROJECT_ROOT_PATH}/third-party/srt

# build
set -x
rm -rf ./_build && mkdir -p _build && cd _build
cmake .. "${PREFERRED_CMAKE_GERERATOR}" \
    -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_ROOT_PATH}/build \
    -DENABLE_SHARED=OFF -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_BUILD_TYPE=${FFMPEG_BUILD_TYPE_INTERNAL} \
    ${PLATFORM_SPECIFIC_PARAMS}
cmake --build . ${MAKE_PARALLEL} && cmake --install .
set +x

# go back
cd ${PROJECT_ROOT_PATH}

