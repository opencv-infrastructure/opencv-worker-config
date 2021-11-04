ARG DOCKER_IMAGE_PREFIX
FROM ${DOCKER_IMAGE_PREFIX}ubuntu:20.04

# https://dgpu-docs.intel.com/installation-guides/ubuntu/ubuntu-focal.html
# oneAPI: https://www.intel.com/content/www/us/en/developer/articles/guide/onevpl-installation-guide.html
# oneVPL: https://www.intel.com/content/www/us/en/develop/documentation/installation-guide-for-intel-oneapi-toolkits-linux/top/installation/install-using-package-managers/apt.html

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends gnupg2 curl ca-certificates && \
  curl -fsSL https://repositories.intel.com/graphics/intel-graphics.key | apt-key add - && \
  echo "deb [arch=amd64] https://repositories.intel.com/graphics/ubuntu focal main" > /etc/apt/sources.list.d/intel-graphics.list && \
  curl -fsSL https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | apt-key add - && \
  echo "deb https://apt.repos.intel.com/oneapi all main" > /etc/apt/sources.list.d/oneAPI.list && \
  apt-get purge --autoremove -y curl && \
  apt-get update && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    intel-oneapi-onevpl-devel-2021.6.0 \
    intel-oneapi-onevpl-2021.6.0 \
    intel-media-va-driver-non-free \
    libmfx1 \
    vainfo \
    && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    clinfo \
    intel-opencl-icd \
    && \
  rm -rf /var/lib/apt/lists/*
