
FROM debian:bullseye-slim

# avoid interactive during apt install
ARG DEBIAN_FRONTEND=noninteractive

# install base tools
COPY *.sh /
RUN /install-tools-debian.sh

# install android ndk
RUN wget --progress=dot:mega https://dl.google.com/android/repository/android-ndk-r23c-linux.zip && \
  unzip android-ndk-r23c-linux.zip && \
  rm android-ndk-r23c-linux.zip && \
  # refer to https://github.com/actions/virtual-environments/blob/main/images/linux/Ubuntu2004-README.md#environment-variables-3
  #   but change ANDROID_SDK_ROOT path to /root/Android/Sdk for android studio auto-sync
  mkdir -p /root/Android/Sdk/ndk/ && \
  mv android-ndk-r23c /root/Android/Sdk/ndk/ && \
  cd /root/Android/Sdk/ && \
  ln -s $(pwd)/ndk/android-ndk-r23c $(pwd)/ndk/23.2.8568313 && \
  ln -s $(pwd)/ndk/android-ndk-r23c $(pwd)/ndk-bundle && \
  echo ANDROID_SDK_ROOT=/root/Android/Sdk >> /etc/environment && \
  echo ANDROID_NDK_ROOT=${ANDROID_SDK_ROOT}/ndk/23.2.8568313 >> /etc/environment && \
  echo ANDROID_NDK_HOME=${ANDROID_NDK_ROOT} >> /etc/environment
  

# for shown on runtime
ARG IMAGE_TAG
ENV IMAGE_TAG ${IMAGE_TAG}
RUN echo IMAGE_TAG=${IMAGE_TAG} >> /etc/environment

# author and source
LABEL maintainer="wangyoucao577@gmail.com"
LABEL org.opencontainers.image.source https://github.com/wangyoucao577/ffmpeg-build

