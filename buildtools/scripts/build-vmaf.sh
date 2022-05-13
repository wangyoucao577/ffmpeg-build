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
cd ${PROJECT_ROOT_PATH}/vmaf/libvmaf

# build
meson build --buildtype release --prefix=${PROJECT_ROOT_PATH}/build --libdir=${PROJECT_ROOT_PATH}/build/lib --default-library static -Denable_tests=false -Denable_docs=false
ninja -vC build install

# copy typical model
cp ${PROJECT_ROOT_PATH}/vmaf/model/vmaf_v0.6.1.json ${PROJECT_ROOT_PATH}/build/bin/

# go back
cd ${PROJECT_ROOT_PATH}

