#!/bin/bash -e

# echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then
    # there's no realpath command on macosx 
    realpath() {
         [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}" 
    }
elif [[ "$OSTYPE" == "msys"* ]]; then

    # to avoid undefined reference to __memcpy_chk error
    # https://github.com/msys2/MINGW-packages/issues/5803
    MSYS_BUILD_EXTRA_PARAMS=(--enable-stack-protector)  
fi
CURRENT_DIR_PATH=$(dirname $(realpath $0))
PROJECT_ROOT_PATH=${CURRENT_DIR_PATH}/../../


source ${CURRENT_DIR_PATH}/options.sh

# enter build foler
cd ${PROJECT_ROOT_PATH}/third-party/opus

# build
set -x
if [[ ${USE_CMAKE} == "TRUE" ]]; then
    mkdir -p build && cd build
    # sed -i "s/FORTIFY_SOURCE=2/FORTIFY_SOURCE=0/g" ../CMakeLists.txt
    cmake .. -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=${PROJECT_ROOT_PATH}/build
    cmake --build . ${MAKE_PARALLEL} && cmake --install .
else
    ./autogen.sh
    ./configure --prefix=${PROJECT_ROOT_PATH}/build --enable-static --disable-shared "${MSYS_BUILD_EXTRA_PARAMS}"
    make ${MAKE_PARALLEL} && make install
fi
set +x

# go back
cd ${PROJECT_ROOT_PATH}

