ARG DOCKER_IMAGE_PREFIX
FROM ${DOCKER_IMAGE_PREFIX}ubuntu:18.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    valgrind \
    && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    gstreamer1.0-tools \
    && \
  rm -rf /var/lib/apt/lists/*
