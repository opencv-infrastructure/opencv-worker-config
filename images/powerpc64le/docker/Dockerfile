ARG DOCKER_IMAGE_PREFIX
FROM ${DOCKER_IMAGE_PREFIX}base:18.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    cmake build-essential ccache ninja-build \
    python3 \
    gcc-8-powerpc64le-linux-gnu \
    g++-8-powerpc64le-linux-gnu \
    binutils-powerpc64le-linux-gnu \
    libc6-ppc64-powerpc-cross \
    pkg-config-powerpc64le-linux-gnu \
    && \
  rm -rf /var/lib/apt/lists/*
