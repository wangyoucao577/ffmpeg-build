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
cd ${PROJECT_ROOT_PATH}/third-party/fribidi

# build
set -x
./autogen.sh
./configure --prefix=${PROJECT_ROOT_PATH}/build --enable-static --disable-shared 

# https://github.com/fribidi/fribidi/issues/8
make ${MAKE_PARALLEL} -C lib install

rm -f doc/Makefile
rm -f test/Makefile
rm -f test/unicode-conformance/Makefile
set +x

# go back
cd ${PROJECT_ROOT_PATH}

