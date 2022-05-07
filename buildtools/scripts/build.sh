#!/bin/bash -x

echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then

    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
fi
CURRENT_DIR_PATH=$(dirname $(realpath $0))


# build in order
cd ${CURRENT_DIR_PATH}
./build-svtav1.sh
./build-ffmpeg.sh "$@"
cd - 

