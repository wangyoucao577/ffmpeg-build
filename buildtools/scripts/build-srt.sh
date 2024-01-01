#!/bin/bash -e

PLATFORM_SPECIFIC_PARAMS="-DENABLE_STDCXX_SYNC=ON"

# echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then

    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
elif [[ "$OSTYPE" == "msys"* ]]; then
    # use pthreads on msys
    PLATFORM_SPECIFIC_PARAMS="-DENABLE_STDCXX_SYNC=OFF" 
fi
CURRENT_DIR_PATH=$(dirname $(realpath $0))
PROJECT_ROOT_PATH=${CURRENT_DIR_PATH}/../../


source ${CURRENT_DIR_PATH}/options.sh

if [[ ${PREFERRED_SSL} == "mbedtls" ]]; then
    # -DUSE_STATIC_LIBSTDCXX=ON allows fully static linking
    # later args is the workaround to solve the following issues: correct .pc to avoid full path libmbedtls.a, which will cause ffmepg with libsrt(with libmbedtls) check fail
    ENC_LIB_EXTRA_PARAMS=(-DUSE_ENCLIB=mbedtls -DENABLE_CXX_DEPS=OFF -DUSE_STATIC_LIBSTDCXX=ON -DSSL_LIBRARY_DIRS=${PROJECT_ROOT_PATH}/build/lib -DCMAKE_EXE_LINKER_FLAGS=-L${PROJECT_ROOT_PATH}/build/lib -DSSL_INCLUDE_DIRS=${PROJECT_ROOT_PATH}/build/include)
else
    ENC_LIB_EXTRA_PARAMS=(-DOPENSSL_USE_STATIC_LIBS=ON -DUSE_OPENSSL_PC=ON)
fi

# enter build foler
cd ${PROJECT_ROOT_PATH}/third-party/srt

# build
set -x
rm -rf ./_build && mkdir -p _build && cd _build
cmake .. "${PREFERRED_CMAKE_GERERATOR}" \
    -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_ROOT_PATH}/build \
    -DENABLE_STATIC=ON -DENABLE_SHARED=OFF \
    -DCMAKE_BUILD_TYPE=${FFMPEG_BUILD_TYPE_INTERNAL} \
    ${PLATFORM_SPECIFIC_PARAMS} "${ENC_LIB_EXTRA_PARAMS[@]}"
cmake --build . ${MAKE_PARALLEL} && cmake --install .
set +x

# go back
cd ${PROJECT_ROOT_PATH}

