#!/bin/bash -x

echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then

    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
fi
CURRENT_DIR_PATH=$(dirname $(realpath $0))
PROJECT_ROOT_PATH=${CURRENT_DIR_PATH}/../../

source ${CURRENT_DIR_PATH}/export-pkg-path.sh

if [[ ${DISABLE_BEAR,,} = "true" || ${DISABLE_BEAR} = "1" ]]; then
    source ${CURRENT_DIR_PATH}/make-parallel-check.sh
else
    BEAR_COMMAND="${PROJECT_ROOT_PATH}/build/bin/bear -- " 
    MAKE_PARALLEL=""    # parallel make may fail due to bear
fi

# enter build foler
cd ${PROJECT_ROOT_PATH}/ffmpeg

# build ffmpeg, extra params will be appended at the end
./configure --prefix=${PROJECT_ROOT_PATH}/build --enable-gpl --enable-nonfree --enable-pic --enable-static --disable-shared --enable-libsvtav1 "$@"
${BEAR_COMMAND} make ${MAKE_PARALLEL} 
make install

# go back
cd -

