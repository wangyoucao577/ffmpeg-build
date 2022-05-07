#!/bin/bash -ex

echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then

    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
fi
CURRENT_DIR_PATH=$(dirname $(realpath $0))
PROJECT_ROOT_PATH=${CURRENT_DIR_PATH}/../../

cd ${PROJECT_ROOT_PATH}/buildtools/bear

# Prerequisites
# apt-get install python cmake pkg-config
# apt-get install libfmt-dev libspdlog-dev nlohmann-json3-dev \
#                 libgrpc++-dev protobuf-compiler-grpc libssl-dev
# See more details in https://github.com/rizsotto/Bear/blob/master/INSTALL.md

mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=${PROJECT_ROOT_PATH}/build -DENABLE_UNIT_TESTS=OFF -DENABLE_FUNC_TESTS=OFF ..
make all
make install
cd ..

cd ../..
