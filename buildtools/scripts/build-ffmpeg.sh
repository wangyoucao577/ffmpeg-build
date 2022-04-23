#!/bin/bash -x

echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then

    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
fi

CURRENT_DIR_PATH=$(dirname $(realpath $0))
PROJECT_ROOT_PATH=${CURRENT_DIR_PATH}/../../

# enter build foler
cd ${PROJECT_ROOT_PATH}/ffmpeg

# build ffmpeg, extra params will be appended at the end
./configure --prefix=${PROJECT_ROOT_PATH}/build --enable-gpl --enable-nonfree --enable-pic --enable-libsvtav1 "$@"
make && make install

# go back
cd -

