ARG DOCKER_IMAGE_PREFIX
FROM ${DOCKER_IMAGE_PREFIX}oneapi-2021.4.0

# Select packages: apt-cache depends intel-hpckit-2021.4.0
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic-2021.4.0 \
    && \
  rm -rf /var/lib/apt/lists/*
