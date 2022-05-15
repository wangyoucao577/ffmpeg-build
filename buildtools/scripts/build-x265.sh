#!/bin/bash -ex

echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then

    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
fi
CURRENT_DIR_PATH=$(dirname $(realpath $0))
PROJECT_ROOT_PATH=${CURRENT_DIR_PATH}/../../


source ${CURRENT_DIR_PATH}/options.sh

# enter build foler
cd ${PROJECT_ROOT_PATH}/x265/build

# build
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=${PROJECT_ROOT_PATH}/build -DENABLE_SHARED=off ../source
make ${MAKE_PARALLEL} && make install

# go back
cd -

