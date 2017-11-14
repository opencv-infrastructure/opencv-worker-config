FROM opencv-base:17.10

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    cmake build-essential ccache ninja-build \
    python3 \
    gcc-7-powerpc64le-linux-gnu \
    g++-7-powerpc64le-linux-gnu \
    binutils-powerpc64le-linux-gnu \
    libc6-ppc64-powerpc-cross \
    pkg-config-powerpc64le-linux-gnu \
    && \
  rm -rf /var/lib/apt/lists/*
