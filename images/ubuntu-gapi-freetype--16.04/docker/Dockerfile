ARG DOCKER_IMAGE_PREFIX
FROM ${DOCKER_IMAGE_PREFIX}ubuntu:16.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    ttf-wqy-microhei ttf-wqy-zenhei \
    && \
  rm -rf /var/lib/apt/lists/*
