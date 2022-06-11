#!/bin/bash -e

# echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then

    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
elif [[ "$OSTYPE" == "msys"* ]]; then
    # disable boringssl since don't want to debug on github action at the moment
    echo "boringssl on ${OSTYPE} currently disabled"
    exit 0
fi
CURRENT_DIR_PATH=$(dirname $(realpath $0))
PROJECT_ROOT_PATH=${CURRENT_DIR_PATH}/../../


source ${CURRENT_DIR_PATH}/options.sh

# enter build foler
cd ${PROJECT_ROOT_PATH}/third-party/boringssl

# patch for msvc
if [[ "$OSTYPE" == "msys"* ]]; then
    sed -i 's/C5045"/C5045 C5105"/g' CMakeLists.txt
fi

# build
set -x
rm -rf ./build && mkdir -p build && cd build
cmake .. "${PREFERRED_CMAKE_GERERATOR}" \
    -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_ROOT_PATH}/build \
    -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_BUILD_TYPE=Release
cmake --build . ${MAKE_PARALLEL} 

if [[ ${PREFERRED_SSL} == boringssl ]]; then
    cmake --install . 
fi

set +x

# go back
cd ${PROJECT_ROOT_PATH}

