ARG DOCKER_IMAGE_PREFIX
FROM ${DOCKER_IMAGE_PREFIX}ubuntu:20.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    clang \
    && \
  rm -rf /var/lib/apt/lists/*
