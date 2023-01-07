

FROM ubuntu:22.04

# avoid interactive during apt install
ARG DEBIAN_FRONTEND=noninteractive

# install base tools
COPY *.sh /
RUN /install-tools-debian.sh

# for shown on runtime
ARG IMAGE_TAG
ENV IMAGE_TAG ${IMAGE_TAG}
RUN echo IMAGE_TAG=${IMAGE_TAG} >> /etc/environment

# author and source
LABEL maintainer="wangyoucao577@gmail.com"
LABEL org.opencontainers.image.source https://github.com/wangyoucao577/ffmpeg-build

