

FROM debian:bullseye-slim

# avoid interactive during apt install
ARG DEBIAN_FRONTEND=noninteractive

# Install basic packages
RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential pkg-config \
  vim curl wget git git-lfs jq zip unzip tree \
  lsb-release software-properties-common gnupg2 autoconf \
  locales-all ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# for shown on runtime
ARG IMAGE_TAG
ENV IMAGE_TAG ${IMAGE_TAG}
RUN echo IMAGE_TAG=${IMAGE_TAG} >> /etc/environment

# author and source
LABEL maintainer="wangyoucao577@gmail.com"
LABEL org.opencontainers.image.source https://github.com/wangyoucao577/ffmpeg-build
