#!/bin/bash -e

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

# build type
if [[ ${BUILD_TYPE} == "debug" ]]; then
    FFMPEG_DEBUG_PARAMS=(--enable-debug=3 --disable-optimizations --disable-stripping --extra-cflags=-fno-omit-frame-pointer --extra-cflags=-fno-inline)
fi

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
# ready but NOT add: --enable-librtmp
./configure --prefix=${PROJECT_ROOT_PATH}/build  --enable-gpl --enable-version3 --enable-nonfree \
  --enable-pic --pkg-config-flags="--static" --ld=g++ --extra-libs="-pthread -ldl" \
  --enable-libvmaf \
  --enable-libx264 --enable-libx265 --enable-libsvtav1 --enable-libaom \
  --enable-libopus --enable-libfdk-aac \
  --enable-sdl \
  --enable-libsrt \
  --enable-openssl \
  ${FFMPEG_STATIC_SHARED_PARAMS} "${FFMPEG_WITH_NV_PARAMS[@]}" "${FFMPEG_DEBUG_PARAMS[@]}" "$@"
${BEAR_COMMAND} make ${MAKE_PARALLEL}
make install


cd ${PROJECT_ROOT_PATH}

# assign permissions
chmod +x build/bin/*

# package dependencies dll on windows
if [[ "$OSTYPE" == msys* ]]; then
    ldd build/bin/ffmpeg | grep -i ${MSYSTEM} | awk '{system("cp "$3" ./build/bin/")}'
fi

