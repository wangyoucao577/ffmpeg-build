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
cd ${PROJECT_ROOT_PATH}/third-party/mbedtls

# build
set -x
rm -rf ./build && mkdir -p build && cd build
cmake .. "${PREFERRED_CMAKE_GERERATOR}" -DCMAKE_INSTALL_PREFIX=${PROJECT_ROOT_PATH}/build -DENABLE_PROGRAMS=OFF -DENABLE_TESTING=OFF
cmake --build . ${MAKE_PARALLEL} && cmake --install .
set +x

# go back
cd ${PROJECT_ROOT_PATH}

