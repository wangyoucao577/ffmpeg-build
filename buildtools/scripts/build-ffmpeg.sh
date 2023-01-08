#!/bin/bash -e

FFMPEG_STATIC_SHARED_PARAMS="--enable-static --disable-shared"

# echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then
    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
elif [[ "$OSTYPE" == msys* ]]; then
    # build shared on windows
    FFMPEG_STATIC_SHARED_PARAMS="--disable-static --enable-shared"
    MSYS_BUILD_EXTRA_LDFLAGS=(-fstack-protector)  # to avoid error when link opus
elif [[ "$OSTYPE" == "linux"* ]]; then
    # only want to static linking programs on linux (could be work on msys2(windows) either, but don't want to)
    FFMPEG_PROGRAMS_STATIC_LINKING="--extra-ldexeflags=-static"
fi
CURRENT_DIR_PATH=$(dirname $(realpath $0))
PROJECT_ROOT_PATH=${CURRENT_DIR_PATH}/../../

source ${CURRENT_DIR_PATH}/options.sh

# build type, toolchain
if [[ ${FFMPEG_BUILD_TYPE_INTERNAL} == "Debug" ]]; then
    FFMPEG_DEBUG_PARAMS=(--enable-debug=3 --disable-optimizations --disable-stripping --extra-cflags=-fno-omit-frame-pointer --extra-cflags=-fno-inline)
fi
FFMPEG_TOOLCHAIN_PARAMS=
if [[ ${FFMPEG_TOOLCHAIN_VALGRIND_MEMCHECK} =~ "true" ]]; then
    FFMPEG_TOOLCHAIN_PARAMS="--toolchain=valgrind-memcheck"
fi
if [[ ${FFMPEG_TOOLCHAIN_COVERAGE} =~ "true" ]]; then
    FFMPEG_TOOLCHAIN_PARAMS="--toolchain=gcov"
fi

# whether enable nvidia gpu
if [[ ${NVIDIA_GPU_AVAILABLE} == "true" ]]; then

    # 1. How to make the FFMPEG_WITH_NV_PARAMS work see
    #    https://superuser.com/questions/360966/how-do-i-use-a-bash-variable-string-containing-quotes-in-a-command
    # 2. `--nvccflags="-gencode arch=compute_75,code=sm_75 -O2"` is required for ffmpeg version before n5.0, 
    #    otherwise `ERROR: failed checking for nvcc.` will occur.
    FFMPEG_WITH_NV_PARAMS=(--enable-cuda-nvcc --enable-nvenc --enable-nvdec --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --nvccflags="-gencode arch=compute_75,code=sm_75 -O2")

    # should be disabled to link cuda libraries dynamically
    FFMPEG_PROGRAMS_STATIC_LINKING=
fi

if [[ ${PREFERRED_SSL} == "mbedtls" ]]; then
    FFMPEG_WITH_SSL_PARAMS=(--enable-mbedtls --extra-ldflags=-L${PROJECT_ROOT_PATH}/build/lib)
else
    FFMPEG_WITH_SSL_PARAMS=(--enable-openssl)

    # should be disabled to link openssl/boringssl libraries dynamically
    FFMPEG_PROGRAMS_STATIC_LINKING=
fi

# enter build folder
cd ${PROJECT_ROOT_PATH}/ffmpeg

# build ffmpeg, extra params will be appended at the end
# 1. ready but NOT add, too old and don't like to use: --enable-librtmp
# 2. static linking executable: --extra-ldexeflags="-static"
#    by this option, `ldd build/bin/ffmpeg` will shows `not a dynamic executable`
#    after add this option, openssl need to be disabled since it requires `-ldl` for `dlopen` functions.
#    `--enable-mbedtls` could be an anlternative in such case.    
#    other options that requires dynamic linking are also need to be removed, such as `--enable-libnpp` and so on. 
#    one more thing is that it may only useful for linux, because macosx doesn't provide static linkable libc, 
#    cygwin/msys2/mingw env also requies to link their DLL.    
set -x
./configure --prefix=${PROJECT_ROOT_PATH}/build \
  --enable-gpl --enable-version3 --enable-nonfree \
  --enable-pic --pkg-config-flags="--static" --ld=g++ \
  --extra-ldflags="${MSYS_BUILD_EXTRA_LDFLAGS}" --extra-libs="-pthread" \
  --enable-libvmaf \
  --enable-libx264 --enable-libx265 --enable-libsvtav1 --enable-libaom --enable-libdav1d \
  --enable-libopus --enable-libfdk-aac --enable-libsoxr \
  --enable-libfreetype --enable-libfontconfig --enable-libfribidi --enable-libass \
  --enable-sdl \
  --enable-libsrt \
  ${FFMPEG_STATIC_SHARED_PARAMS} ${FFMPEG_PROGRAMS_STATIC_LINKING} ${FFMPEG_TOOLCHAIN_PARAMS} \
  "${FFMPEG_WITH_SSL_PARAMS[@]}" "${FFMPEG_WITH_NV_PARAMS[@]}" "${FFMPEG_DEBUG_PARAMS[@]}" "$@"
make -i clean
${BEAR_COMMAND} make ${BEAR_MAKE_PARALLEL} build
make install

# fate https://ffmpeg.org/fate.html
if [[ ${FFMPEG_ENABLE_FATE_TESTS} =~ "true" ]]; then
    make fate-list
    make fate-rsync SAMPLES=${PROJECT_ROOT_PATH}/ffmpeg-fate-suite/
    make fate       SAMPLES=${PROJECT_ROOT_PATH}/ffmpeg-fate-suite/ V=2
fi

set +x

cd ${PROJECT_ROOT_PATH}

# assign permissions
chmod +x build/bin/*

# package dependencies dll on windows
if [[ "$OSTYPE" == msys* ]]; then
    ldd build/bin/ffmpeg | grep -i ${MSYSTEM} | awk '{system("cp "$3" ./build/bin/")}'
fi
