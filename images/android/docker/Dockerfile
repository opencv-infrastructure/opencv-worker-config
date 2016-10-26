FROM opencv-base:16.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    cmake build-essential ccache ninja-build \
    python \
    ant ant-optional default-jdk \
    && \
  rm -rf /var/lib/apt/lists/*

RUN \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libncurses5:i386 libstdc++6:i386 zlib1g:i386 \
    && \
  rm -rf /var/lib/apt/lists/*
