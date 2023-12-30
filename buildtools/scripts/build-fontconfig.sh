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
cd ${PROJECT_ROOT_PATH}/third-party/fontconfig

# build
set -x
rm -rf fontconfig-2.12.6
tar -zxf fontconfig-2.12.6.tar.gz
cd fontconfig-2.12.6
./configure --prefix=${PROJECT_ROOT_PATH}/build --enable-static --disable-shared --enable-libxml2 --disable-docs

if [[ "$OSTYPE" == "darwin"* && $(uname -m) == "arm64" ]]; then
    # disable fc-cache test to avoid segmentation fault on macosx arm64
    sed -i'' -e "s/RUN_FC_CACHE_TEST = test/\#RUN_FC_CACHE_TEST = test/g" Makefile
    sed -i'' -e "s/\#RUN_FC_CACHE_TEST = false/RUN_FC_CACHE_TEST = false/g" Makefile
fi 

make ${MAKE_PARALLEL} && make install

# package sample fonts with bin
cp -r ${PROJECT_ROOT_PATH}/tests/*.ttf ${PROJECT_ROOT_PATH}/build/bin/

set +x

# go back
cd ${PROJECT_ROOT_PATH}

