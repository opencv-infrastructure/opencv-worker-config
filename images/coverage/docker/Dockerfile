ARG DOCKER_IMAGE_PREFIX
FROM ${DOCKER_IMAGE_PREFIX}ubuntu:18.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    lcov \
    && \
  rm -rf /var/lib/apt/lists/*
