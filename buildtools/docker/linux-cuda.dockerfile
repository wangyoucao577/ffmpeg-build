FROM nvidia/cuda:11.3.1-devel-ubuntu20.04

# nvidia-container-runtime envs, see https://github.com/NVIDIA/nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all

# avoid interactive during apt install
ARG DEBIAN_FRONTEND=noninteractive

# install base tools
COPY *.sh /
RUN /install-tools-debian.sh

# install cudnn, tensorrt
# cudnn: https://docs.nvidia.com/deeplearning/cudnn/install-guide/index.html#package-manager-ubuntu-install
# versions: https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/
# tensorrt: https://docs.nvidia.com/deeplearning/tensorrt/install-guide/index.html#maclearn-net-repo-install
# tensorrt: https://docs.nvidia.com/deeplearning/tensorrt/quick-start-guide/index.html#installing-debian
# be aware that tensorrt 8.4.3.1-1+cuda11.6 compatible with cuda11.2
# RUN wget --progress=dot:mega --no-check-certificate https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin && \
#   mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
#   apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub && \
#   add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" && \
#   apt-get update && \
#   apt-get install --no-install-recommends -y \
#     tensorrt-libs=8.5.2.2-1+cuda11.8 tensorrt-dev=8.5.2.2-1+cuda11.8 && \
#   rm -rf /var/lib/apt/lists/*

# for shown on runtime
ARG IMAGE_TAG
ENV IMAGE_TAG ${IMAGE_TAG}
RUN echo IMAGE_TAG=${IMAGE_TAG} >> /etc/environment

# author and source
LABEL maintainer="wangyoucao577@gmail.com"
LABEL org.opencontainers.image.source https://github.com/wangyoucao577/ffmpeg-build


