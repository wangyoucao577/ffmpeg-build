#!/bin/bash -x

echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then

    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
fi
CURRENT_DIR_PATH=$(dirname $(realpath $0))
PROJECT_ROOT_PATH=${CURRENT_DIR_PATH}/../../

# use "${PROJECT_ROOT_PATH}/build" as build dependencies path
export LD_LIBRARY_PATH="${PROJECT_ROOT_PATH}/build/lib:${LD_LIBRARY_PATH}"
export PKG_CONFIG_PATH="${PROJECT_ROOT_PATH}/build/lib/pkgconfig:${PKG_CONFIG_PATH}"
