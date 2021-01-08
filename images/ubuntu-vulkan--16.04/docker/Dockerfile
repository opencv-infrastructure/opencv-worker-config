ARG DOCKER_IMAGE_PREFIX
FROM ${DOCKER_IMAGE_PREFIX}ubuntu:16.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libvulkan1 \
    mesa-vulkan-drivers \
    && \
  rm -rf /var/lib/apt/lists/*
