ARG DOCKER_IMAGE_PREFIX
FROM ${DOCKER_IMAGE_PREFIX}base:16.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    cmake build-essential ccache ninja-build \
    python \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    binutils-aarch64-linux-gnu \
    pkg-config-aarch64-linux-gnu \
    && \
  rm -rf /var/lib/apt/lists/*
