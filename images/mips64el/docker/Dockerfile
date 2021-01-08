ARG DOCKER_IMAGE_PREFIX
FROM ${DOCKER_IMAGE_PREFIX}base:18.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    cmake build-essential ccache ninja-build \
    python3 \
    gcc-8-mips64el-linux-gnuabi64 \
    g++-8-mips64el-linux-gnuabi64 \
    pkg-config-mips64el-linux-gnuabi64 \
    && \
  rm -rf /var/lib/apt/lists/*
