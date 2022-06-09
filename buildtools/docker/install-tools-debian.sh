#!/bin/bash -e

# Install basic packages
apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  build-essential pkg-config automake libtool python3-pip \
  yasm nasm libssl-dev \
  vim curl wget git jq zip unzip tree stow \
  lsb-release software-properties-common gnupg2 autoconf \
  locales-all ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# install meson
pip3 install meson && \
  meson --version

# install cmake
wget --progress=dot:mega https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-linux-x86_64.tar.gz && \
  tar -zxf cmake-3.23.1-linux-x86_64.tar.gz && \
  mv cmake-3.23.1-linux-x86_64 /usr/local/ && \
  rm cmake-3.23.1-linux-x86_64.tar.gz && \
  cd /usr/local/cmake-3.23.1-linux-x86_64/ && \
  stow -v --ignore=man . && \
  cmake --version

# install ninja
wget --progress=dot:mega https://github.com/ninja-build/ninja/releases/download/v1.10.2/ninja-linux.zip && \
  unzip ninja-linux.zip && \
  mv ninja /usr/local/bin/ && \
  rm -f ninja-linux.zip && \
  ninja --version

# install go
wget --progress=dot:mega --no-check-certificate https://go.dev/dl/$(curl https://go.dev/VERSION?m=text).linux-amd64.tar.gz -O go.linux-amd64.tar.gz && \
  tar -zxf go.linux-amd64.tar.gz && \
  mv go /usr/local/ && \
  rm -f go.linux-amd64.tar.gz && \
  cd /usr/local/go/ && \
  stow -v -t ../bin bin && \
  cd ~ && \
  go version
