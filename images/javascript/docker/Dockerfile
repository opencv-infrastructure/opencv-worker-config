ARG DOCKER_IMAGE_PREFIX
FROM ${DOCKER_IMAGE_PREFIX}base:16.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    cmake build-essential \
    python \
    && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    rsync \
    && \
  rm -rf /var/lib/apt/lists/*
