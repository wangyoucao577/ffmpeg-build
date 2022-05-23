#!/bin/bash -e

echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then

    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }

    SYS=darwin
elif [[ "$OSTYPE" == "linux"* ]]; then
    SYS=posix
elif [[ "$OSTYPE" == "msys"* ]]; then
    SYS=mingw
else
    echo "unsupported OS ${OSTYPE}" 
    exit 1
fi
CURRENT_DIR_PATH=$(dirname $(realpath $0))
PROJECT_ROOT_PATH=${CURRENT_DIR_PATH}/../../


source ${CURRENT_DIR_PATH}/options.sh

# enter build foler
cd ${PROJECT_ROOT_PATH}/rtmpdump

# build
make install ${MAKE_PARALLEL} SYS=${SYS} SHARED= CRYPTO= XDEF=-DNO_SSL prefix=${PROJECT_ROOT_PATH}/build

# go back
cd ${PROJECT_ROOT_PATH}

