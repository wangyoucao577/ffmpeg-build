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

source ${CURRENT_DIR_PATH}/options.sh

# whether enable nvidia gpu
if [[ ${NVIDIA_GPU_AVAILABLE} == "true" ]]; then

    # 1. How to make the FFMPEG_WITH_NV_PARAMS work see
    #    https://superuser.com/questions/360966/how-do-i-use-a-bash-variable-string-containing-quotes-in-a-command
    # 2. `--nvccflags="-gencode arch=compute_75,code=sm_75 -O2"` is required for ffmpeg version before n5.0, 
    #    otherwise `ERROR: failed checking for nvcc.` will occur.
    FFMPEG_WITH_NV_PARAMS=(--enable-cuda-nvcc --enable-nvenc --enable-nvdec --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --nvccflags="-gencode arch=compute_75,code=sm_75 -O2")
fi

if [[ ${DISABLE_BEAR} =~ "true" ]] || [[ ${DISABLE_BEAR} =~ "1" ]]; then 
    :
else
    MAKE_PARALLEL=""    # parallel make may fail due to bear
fi

# enter build folder
cd ${PROJECT_ROOT_PATH}/ffmpeg

# build ffmpeg, extra params will be appended at the end
./configure --prefix=${PROJECT_ROOT_PATH}/build --enable-gpl --enable-nonfree --enable-pic --enable-openssl --enable-libx264 --enable-libsvtav1 ${FFMPEG_STATIC_SHARED_PARAMS} "${FFMPEG_WITH_NV_PARAMS[@]}" "$@"
${BEAR_COMMAND} make ${MAKE_PARALLEL} 
make install

# go back
cd -

# package dependencies dll on windows
if [[ "$OSTYPE" == msys* ]]; then
    ldd build/bin/ffmpeg | grep -i ${MSYSTEM} | awk '{system("cp "$3" ./build/bin/")}'
fi

