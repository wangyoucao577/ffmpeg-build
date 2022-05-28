#!/bin/bash 

# echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then

    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
fi

CURRENT_DIR_PATH=$(dirname $(realpath $0))
PROJECT_ROOT_PATH=${CURRENT_DIR_PATH}/../../

# enter build foler
cd ${PROJECT_ROOT_PATH}/third-party/nv-codec-headers 

# build, install to customized build folder
set -x
make install PREFIX=${PROJECT_ROOT_PATH}/build
set +x

# go back
cd ${PROJECT_ROOT_PATH}

