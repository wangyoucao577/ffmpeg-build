

FROM debian:bullseye-slim

# avoid interactive during apt install
ARG DEBIAN_FRONTEND=noninteractive

# install base tools
COPY *.sh /
RUN /install-tools-debian.sh

# install bear, https://github.com/rizsotto/Bear/blob/master/INSTALL.md
RUN git clone -n https://github.com/rizsotto/Bear.git && \
  cd Bear && git checkout 3.0.19 && \
  mkdir -p build && cd build && \
  cmake -DENABLE_UNIT_TESTS=OFF -DENABLE_FUNC_TESTS=OFF ..  && \
  make -j $(nproc) && make install && \
  cd ../../ && \
  /usr/local/bin/bear --version && \
  rm -rf ./Bear

# for shown on runtime
ARG IMAGE_TAG
ENV IMAGE_TAG ${IMAGE_TAG}
RUN echo IMAGE_TAG=${IMAGE_TAG} >> /etc/environment

# author and source
LABEL maintainer="wangyoucao577@gmail.com"
LABEL org.opencontainers.image.source https://github.com/wangyoucao577/ffmpeg-build

