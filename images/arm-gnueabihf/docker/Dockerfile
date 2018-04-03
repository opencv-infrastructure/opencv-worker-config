FROM opencv-base:14.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    cmake3 build-essential ccache ninja-build \
    python \
    gcc-arm-linux-gnueabihf \
    g++-arm-linux-gnueabihf \
    binutils-arm-linux-gnueabihf \
    pkg-config-arm-linux-gnueabihf \
    && \
  rm -rf /var/lib/apt/lists/*
