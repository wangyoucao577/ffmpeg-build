#!/bin/bash

# platform specific options
echo "OSTYPE: $OSTYPE"
if [[ "$OSTYPE" == "linux"* ]]; then
    :   # nothing to do
elif [[ "$OSTYPE" == "darwin"* ]]; then
    :
else # other types
    DISABLE_BEAR=true
fi

# MAKE_PARALLEL, disable parallel on Github Action
[ -z "${GITHUB_ACTION}" ] && MAKE_PARALLEL="-j"

# DISABLE_BEAR, enable for linux and mac
if [[ ${DISABLE_BEAR,,} = "true" || ${DISABLE_BEAR} = "1" ]]; then
    :
else
    BEAR_COMMAND="${PROJECT_ROOT_PATH}/build/bin/bear -- " 
    MAKE_PARALLEL=""    # parallel make may fail due to bear
fi

# NVIDIA_GPU_AVAILABLE, hardware and drivers/sdk relevant
if [ -d "/usr/local/cuda" ] && command -v nvidia-smi &> /dev/null ; then
    echo "Nvidia gpu available"

    NVIDIA_GPU_AVAILABLE=true
fi
