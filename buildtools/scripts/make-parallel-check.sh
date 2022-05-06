#!/bin/bash

# check whether possible to enable parallel make 
MAKE_PARALLEL="-j"
if [ ! -z "${GITHUB_ACTION}" ]; then
    MAKE_PARALLEL=""    # disable parallel on Github Action
fi
