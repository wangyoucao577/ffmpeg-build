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
cd ${PROJECT_ROOT_PATH}/third-party/freetype/

# build
set -x
rm -rf freetype-2.12.1
tar -zxf freetype-2.12.1.tar.gz
cd freetype-2.12.1
./configure --prefix=${PROJECT_ROOT_PATH}/build --enable-static --disable-shared --enable-freetype-config
make ${MAKE_PARALLEL} && make install
set +x

# go back
cd ${PROJECT_ROOT_PATH}

