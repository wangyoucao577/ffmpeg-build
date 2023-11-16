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
cd ${PROJECT_ROOT_PATH}/third-party/vmaf/libvmaf

# whether enable nvidia gpu
if [[ ${NVIDIA_GPU_AVAILABLE} == "true" ]]; then
    LIBVMAF_WITH_NV_PARAMS=(-Denable_cuda=true)
fi

# build
set -x
meson build --buildtype release --prefix=${PROJECT_ROOT_PATH}/build --libdir=${PROJECT_ROOT_PATH}/build/lib --default-library static -Denable_tests=false -Denable_docs=false "${LIBVMAF_WITH_NV_PARAMS[@]}" 
ninja -vC build install
set +x

# go back
cd ${PROJECT_ROOT_PATH}

