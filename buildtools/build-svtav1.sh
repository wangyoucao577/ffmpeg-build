#!/bin/bash -x

echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then

    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
fi

CURRENT_SCRIPT_PATH=$(realpath $0)
CURRENT_DIR_PATH=$(dirname $CURRENT_SCRIPT_PATH)

# enter build foler
cd ${CURRENT_DIR_PATH}/../SVT-AV1/Build

# build svt-av1
cmake .. -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=$(pwd)/../../build -DBUILD_SHARED_LIBS=OFF
make && make install

# go back
cd -

