ARG DOCKER_IMAGE_PREFIX
FROM ${DOCKER_IMAGE_PREFIX}base:14.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    cmake build-essential ccache ninja-build \
    python \
    ant openjdk-7-jdk openjdk-7-jre \
    && \
  rm -rf /var/lib/apt/lists/*

# Some Andoid SDK tools are 32-bit
RUN \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libncurses5:i386 libstdc++6:i386 zlib1g:i386 \
    && \
  rm -rf /var/lib/apt/lists/*

# OpenCV 2.4 Android pack
RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    python-sphinx texlive-full \
    && \
  rm -rf /var/lib/apt/lists/*
