#!/bin/bash -ex

FFMPEG_STATIC_SHARED_PARAMS="--enable-static --disable-shared"

echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then
    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
elif [[ "$OSTYPE" == msys* ]]; then
    # build shared on windows
    FFMPEG_STATIC_SHARED_PARAMS="--disable-static --enable-shared"
fi
CURRENT_DIR_PATH=$(dirname $(realpath $0))
PROJECT_ROOT_PATH=${CURRENT_DIR_PATH}/../../

source ${CURRENT_DIR_PATH}/export-pkg-path.sh

# whether enable bear(disable parallel to avoid error)
echo "DISABLE_BEAR: ${DISABLE_BEAR}" 
if [[ ${DISABLE_BEAR,,} = "true" || ${DISABLE_BEAR} = "1" ]]; then
    source ${CURRENT_DIR_PATH}/make-parallel-check.sh
else
    BEAR_COMMAND="${PROJECT_ROOT_PATH}/build/bin/bear -- " 
    MAKE_PARALLEL=""    # parallel make may fail due to bear
fi

# whether enable nvidia gpu
if [ -d "/usr/local/cuda" ] && command -v nvidia-smi &> /dev/null ; then
    echo "Nvidia gpu available"

    # 1. How to make the FFMPEG_WITH_NV_PARAMS work see
    #    https://superuser.com/questions/360966/how-do-i-use-a-bash-variable-string-containing-quotes-in-a-command
    # 2. `--nvccflags="-gencode arch=compute_75,code=sm_75 -O2"` is required for ffmpeg version before n5.0, 
    #    otherwise `ERROR: failed checking for nvcc.` will occur.
    FFMPEG_WITH_NV_PARAMS=(--enable-cuda-nvcc --enable-nvenc --enable-nvdec --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --nvccflags="-gencode arch=compute_75,code=sm_75 -O2")
fi

# enter build foler
cd ${PROJECT_ROOT_PATH}/ffmpeg

# build ffmpeg, extra params will be appended at the end
./configure --prefix=${PROJECT_ROOT_PATH}/build --enable-gpl --enable-nonfree --enable-pic --enable-libsvtav1 "${FFMPEG_STATIC_SHARED_PARAMS}" "${FFMPEG_WITH_NV_PARAMS[@]}" "$@"
${BEAR_COMMAND} make ${MAKE_PARALLEL} 
make install

# go back
cd -

