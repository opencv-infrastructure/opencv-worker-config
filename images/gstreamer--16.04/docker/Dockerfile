ARG DOCKER_IMAGE_PREFIX
FROM ${DOCKER_IMAGE_PREFIX}ubuntu:16.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
        gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-libav \
    libdc1394-22-dev \
    libgphoto2-dev \
    && \
  rm -rf /var/lib/apt/lists/*
