#!/bin/bash -e

# echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then

    realpath() { # there's no realpath command on macosx 
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
fi
CURRENT_DIR_PATH=$(dirname $(realpath $0))
PROJECT_ROOT_PATH=${CURRENT_DIR_PATH}/../../


source ${CURRENT_DIR_PATH}/options.sh

# enter build foler
cd ${PROJECT_ROOT_PATH}/third-party/x265/build

# build multilib, refer to x265/build/linux/multilib.sh
set -x

mkdir -p 8bit 10bit 12bit

cd 12bit
cmake ../../source "${PREFERRED_CMAKE_GERERATOR}" -DCMAKE_INSTALL_PREFIX=${PROJECT_ROOT_PATH}/build \
    -DCMAKE_ASM_NASM_FLAGS=-w-macro-params-legacy \
    -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF -DENABLE_SHARED=OFF -DENABLE_CLI=OFF -DMAIN12=ON
cmake --build . ${MAKE_PARALLEL} 

cd ../10bit
cmake ../../source "${PREFERRED_CMAKE_GERERATOR}" -DCMAKE_INSTALL_PREFIX=${PROJECT_ROOT_PATH}/build \
    -DCMAKE_ASM_NASM_FLAGS=-w-macro-params-legacy \
    -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF -DENABLE_SHARED=OFF -DENABLE_CLI=OFF
cmake --build . ${MAKE_PARALLEL} 

cd ../8bit
ln -sf ../10bit/libx265.a libx265_main10.a
ln -sf ../12bit/libx265.a libx265_main12.a
cmake ../../source "${PREFERRED_CMAKE_GERERATOR}" -DCMAKE_INSTALL_PREFIX=${PROJECT_ROOT_PATH}/build \
    -DCMAKE_ASM_NASM_FLAGS=-w-macro-params-legacy \
    -DENABLE_SHARED=OFF -DENABLE_CLI=OFF \
    -DEXTRA_LIB="x265_main10.a;x265_main12.a" -DEXTRA_LINK_FLAGS=-L. -DLINKED_10BIT=ON -DLINKED_12BIT=ON
cmake --build . ${MAKE_PARALLEL} 

# rename the 8bit library, then combine all three into libx265.a
mv libx265.a libx265_main.a

if [[ "$OSTYPE" == "darwin"* ]]; then

# Mac/BSD libtool
libtool -static -o libx265.a libx265_main.a libx265_main10.a libx265_main12.a 2>/dev/null

else

# On Linux, we use GNU ar to combine the static libraries together
ar -M <<EOF
CREATE libx265.a
ADDLIB libx265_main.a
ADDLIB libx265_main10.a
ADDLIB libx265_main12.a
SAVE
END
EOF

fi


cmake --install . 
cd .. && rm -rf ./8bit 10bit 12bit

if [[ "$OSTYPE" == "linux"* ]]; then
    # workaround to be able to fully static linking
    sed -i -e "s/\-lgcc_s//g" ${PROJECT_ROOT_PATH}/build/lib/pkgconfig/x265.pc
fi

set +x

# go back
cd ${PROJECT_ROOT_PATH}

