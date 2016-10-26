FROM opencv-ubuntu:14.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    valgrind \
    && \
  rm -rf /var/lib/apt/lists/*
