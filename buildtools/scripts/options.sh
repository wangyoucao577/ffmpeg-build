#!/bin/bash

# case-insensitive match
shopt -s nocasematch

# platform specific options
echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "linux"* ]]; then
    DISABLE_BEAR=true
elif [[ "$OSTYPE" == "darwin"* ]]; then
    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }

    # export ssl
    export PKG_CONFIG_PATH=$(brew --prefix)/opt/openssl/lib/pkgconfig:${PKG_CONFIG_PATH}
else # other types
    DISABLE_BEAR=true
fi

# use "${PROJECT_ROOT_PATH}/build" as build dependencies path
CURRENT_DIR_PATH=$(dirname $(realpath $0))
PROJECT_ROOT_PATH=${CURRENT_DIR_PATH}/../../
export LD_LIBRARY_PATH="${PROJECT_ROOT_PATH}/build/lib:${LD_LIBRARY_PATH}"
export PKG_CONFIG_PATH="${PROJECT_ROOT_PATH}/build/lib/pkgconfig:${PKG_CONFIG_PATH}"


# MAKE_PARALLEL, disable parallel on Github Action
[ -z "${GITHUB_ACTION}" ] && MAKE_PARALLEL="-j"

# DISABLE_BEAR, enable for linux and mac
if [[ ${DISABLE_BEAR} =~ "true" ]] || [[ ${DISABLE_BEAR} =~ "1" ]]; then
    echo "DISABLE_BEAR=true"
else
    BEAR_COMMAND="bear -- " 
    MAKE_PARALLEL=""    # parallel make may fail due to bear
fi

# NVIDIA_GPU_AVAILABLE, hardware and drivers/sdk relevant
if [ -d "/usr/local/cuda" ] && command -v nvidia-smi &> /dev/null ; then
    echo "Nvidia gpu available"

    NVIDIA_GPU_AVAILABLE=true
fi
