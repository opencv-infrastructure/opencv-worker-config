ARG DOCKER_IMAGE_PREFIX
FROM ${DOCKER_IMAGE_PREFIX}base:12.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    cmake build-essential ccache \
    python-dev python-numpy \
    python3-dev python3-numpy \
    zlib1g-dev libjpeg-dev libpng12-dev libtiff4-dev libjasper-dev \
    libgtk2.0-dev \
    libavformat-dev libavformat-extra-53 libswscale-dev \
    ant ant-optional openjdk-7-jdk openjdk-7-jre \
    hdf5-tools libhdf5-serial-dev \
    libleptonica-dev libleptonica tesseract-ocr tesseract-ocr-eng libtesseract-dev libtesseract3 \
    libusb-dev libusb-1.0.0-dev libudev-dev \
    libgdal-dev \
    libvtk5-dev \
    libatlas-base-dev libeigen3-dev libsuitesparse-dev \
    xvfb \
    && \
  rm -rf /var/lib/apt/lists/*
