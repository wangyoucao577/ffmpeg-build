#!/bin/bash -e

# echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then

    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
fi
CURRENT_DIR_PATH=$(dirname $(realpath $0))
PROJECT_ROOT_PATH=${CURRENT_DIR_PATH}/../../


source ${CURRENT_DIR_PATH}/options.sh

# enter build foler
cd ${PROJECT_ROOT_PATH}/third-party/openssl

# build
set -x
./Configure --prefix=${PROJECT_ROOT_PATH}/build no-shared no-tests
make ${MAKE_PARALLEL} 

if [[ ${PREFERRED_SSL} == openssl ]]; then
    make install
fi

set +x

# go back
cd ${PROJECT_ROOT_PATH}

