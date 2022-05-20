#!/bin/bash

# case-insensitive match
shopt -s nocasematch

# platform specific options
echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "linux"* ]]; then
    :
elif [[ "$OSTYPE" == "darwin"* ]]; then
    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }

    # enable ssl
    export PKG_CONFIG_PATH=$(brew --prefix)/opt/openssl/lib/pkgconfig:${PKG_CONFIG_PATH}
else # other types
    DISABLE_BEAR=true
fi

# use "${PROJECT_ROOT_PATH}/build" as build dependencies path
CURRENT_DIR_PATH=$(dirname $(realpath $0))
PROJECT_ROOT_PATH=${CURRENT_DIR_PATH}/../../
export LD_LIBRARY_PATH="${PROJECT_ROOT_PATH}/build/lib:${LD_LIBRARY_PATH}"
export PKG_CONFIG_PATH="${PROJECT_ROOT_PATH}/build/lib/pkgconfig:${PKG_CONFIG_PATH}"

# build type 
BUILD_TYPE=release
# BUILD_TYPE=debug

# disable parallel and bear on Github Action
if [ -z "${GITHUB_ACTION}" ]; then
    MAKE_PARALLEL="-j"
else
    DISABLE_BEAR=true 
fi

# DISABLE_BEAR, enable for linux and mac
if [[ ${DISABLE_BEAR} =~ "true" ]] || [[ ${DISABLE_BEAR} =~ "1" ]]; then
    echo "DISABLE_BEAR=true"
else
    # requires pre-installed bear, 'brew install bear' or 'apt install bear' or build from source
    # currently only ffmpeg leverages Bear
    BEAR_COMMAND="bear -- " 
fi

# NVIDIA_GPU_AVAILABLE, hardware and drivers/sdk relevant
if [ -d "/usr/local/cuda" ] && command -v nvidia-smi &> /dev/null ; then
    echo "Nvidia gpu available"

    NVIDIA_GPU_AVAILABLE=true
fi
