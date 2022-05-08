

FROM debian:buster-slim

# avoid interactive during apt install
ARG DEBIAN_FRONTEND=noninteractive

# Install basic packages
RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential pkg-config \
  yasm \
  vim curl wget git git-lfs jq zip unzip tree stow \
  lsb-release software-properties-common gnupg2 autoconf \
  locales-all ca-certificates \
  python libssl-dev \
  && rm -rf /var/lib/apt/lists/*

# install cmake
RUN wget --progress=dot:mega https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-linux-x86_64.tar.gz && \
  tar -zxf cmake-3.23.1-linux-x86_64.tar.gz && \
  mv cmake-3.23.1-linux-x86_64 /usr/local/ && \
  rm cmake-3.23.1-linux-x86_64.tar.gz && \
  cd /usr/local/cmake-3.23.1-linux-x86_64/ && \
  stow -v --ignore=man . && \
  cmake --version

# install ninja
RUN wget --progress=dot:mega https://github.com/ninja-build/ninja/releases/download/v1.10.2/ninja-linux.zip && \
  unzip ninja-linux.zip && \
  mv ninja /usr/local/bin/ && \
  rm -f ninja-linux.zip && \
  ninja --version

# install Bear
RUN git clone -n https://github.com/rizsotto/Bear.git && \
  cd Bear && \
  git checkout 3.0.19 && \
  mkdir -p build && cd build && \
  cmake -DENABLE_UNIT_TESTS=OFF -DENABLE_FUNC_TESTS=OFF .. && \
  make all && \
  make install

# for shown on runtime
ARG IMAGE_TAG
ENV IMAGE_TAG ${IMAGE_TAG}
RUN echo IMAGE_TAG=${IMAGE_TAG} >> /etc/environment

# author and source
LABEL maintainer="wangyoucao577@gmail.com"
LABEL org.opencontainers.image.source https://github.com/wangyoucao577/ffmpeg-build

