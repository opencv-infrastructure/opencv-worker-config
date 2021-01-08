ARG DOCKER_IMAGE_PREFIX
FROM ${DOCKER_IMAGE_PREFIX}base:18.04

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    cmake build-essential \
    doxygen doxygen-latex graphviz \
    p7zip-full \
    pylint flake8 \
    python-bs4 \
    python3-bs4 \
    ant ant-optional default-jdk \
    && \
  rm -rf /var/lib/apt/lists/*
