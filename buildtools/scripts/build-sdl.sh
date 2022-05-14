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
cd ${PROJECT_ROOT_PATH}/SDL

# build
if [[ "$OSTYPE" == "darwin"* ]]; then
    MAXOSX_EXTRA_CC="CC=${PROJECT_ROOT_PATH}/SDL/build-scripts/clang-fat.sh"
fi
eval ${MAXOSX_EXTRA_CC} ./configure --prefix=${PROJECT_ROOT_PATH}/build --enable-static --disable-shared
make ${MAKE_PARALLEL} && make install

# go back
cd ${PROJECT_ROOT_PATH}

