FROM opencv-ubuntu:16.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    rsync \
    && \
  rm -rf /var/lib/apt/lists/*

RUN \
  wget https://github.com/bazelbuild/bazelisk/releases/download/v1.1.0/bazelisk-linux-amd64 -O /usr/local/bin/bazelisk && \
  echo "d20be9dfb311c596efd1579d30c0fdab0d5ba62ec76b316ada3a8e69f4194bbe  /usr/local/bin/bazelisk" | sha256sum -c && \
  chmod +x /usr/local/bin/bazelisk

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    python3-venv \
    flex bison \
    && \
  rm -rf /var/lib/apt/lists/*
