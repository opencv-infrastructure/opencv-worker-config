FROM opencv-powerpc64le

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    qemu-user \
    && \
  rm -rf /var/lib/apt/lists/*
