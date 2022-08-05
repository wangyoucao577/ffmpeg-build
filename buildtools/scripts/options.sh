#!/bin/bash

# case-insensitive match
shopt -s nocasematch

# preferred ssl
# PREFERRED_SSL=system
# PREFERRED_SSL=boringssl
PREFERRED_SSL=openssl

# preferred cmake generator
# PREFERRED_CMAKE_GERERATOR=
# PREFERRED_CMAKE_GERERATOR=(-G"Unix Makefiles")
PREFERRED_CMAKE_GERERATOR=(-GNinja)

# platform specific options
# echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "linux"* ]]; then
    NPROC=$(nproc)
elif [[ "$OSTYPE" == "darwin"* ]]; then
    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
    NPROC=$(sysctl -n hw.physicalcpu)
    if [[ ${PREFERRED_SSL} == system ]]; then
        export PKG_CONFIG_PATH=$(brew --prefix)/opt/openssl/lib/pkgconfig:${PKG_CONFIG_PATH}
    fi
else # other types
    NPROC=$(nproc)
fi

# build type, check from env FFMPEG_BUILD_TYPE
# It only affects the libraries that may want to debug, such as ffmpeg, srt, rtmpdump, etc.
MAKE_PARALLEL="-j ${NPROC}"
BEAR_MAKE_PARALLEL=${MAKE_PARALLEL}
if [[ ${FFMPEG_BUILD_TYPE} =~ "debug" ]]; then
    FFMPEG_BUILD_TYPE_INTERNAL="Debug"

    # requires pre-installed bear, 'brew install bear' or 'apt install bear' or build from source
    # disable parallel when enable bear to avoid build error
    BEAR_COMMAND="bear -- " 
    BEAR_MAKE_PARALLEL=  
else
    FFMPEG_BUILD_TYPE_INTERNAL="Release"    # otherwise release
fi


# use "${PROJECT_ROOT_PATH}/build" as build dependencies path
CURRENT_DIR_PATH=$(dirname $(realpath $0))
PROJECT_ROOT_PATH=${CURRENT_DIR_PATH}/../../
export LD_LIBRARY_PATH="${PROJECT_ROOT_PATH}/build/lib:${LD_LIBRARY_PATH}"
export PKG_CONFIG_PATH="${PROJECT_ROOT_PATH}/build/lib/pkgconfig:${PKG_CONFIG_PATH}"
if [[ ${PREFERRED_SSL} == openssl ]]; then
    export LD_LIBRARY_PATH="${PROJECT_ROOT_PATH}/build/lib64:${LD_LIBRARY_PATH}"
    export PKG_CONFIG_PATH="${PROJECT_ROOT_PATH}/build/lib64/pkgconfig:${PKG_CONFIG_PATH}"
fi

# NVIDIA_GPU_AVAILABLE, hardware and drivers/sdk relevant
if [ -d "/usr/local/cuda" ] && command -v nvcc &> /dev/null ; then
    # echo "Nvidia gpu available"

    NVIDIA_GPU_AVAILABLE=true
fi
