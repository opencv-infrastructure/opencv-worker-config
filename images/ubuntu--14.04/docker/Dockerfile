FROM opencv-base:14.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    cmake build-essential ccache \
    python python-dev python-numpy \
    python3 python3-dev python3-numpy \
    zlib1g-dev libjpeg-dev libpng12-dev libtiff5-dev libjasper-dev \
    libgtk2.0-dev \
    libavformat-dev libavformat-extra-54 libswscale-dev \
    ant ant-optional openjdk-7-jdk openjdk-7-jre \
    hdf5-tools hdf5-helpers libhdf5-7 libhdf5-dev libhdf5-serial-dev \
    libleptonica-dev liblept4 tesseract-ocr tesseract-ocr-eng libtesseract-dev libtesseract3 \
    libusb-dev libusb-1.0.0-dev libudev-dev \
    libgdal-dev \
    libvtk6-dev \
    libgoogle-glog-dev \
    libatlas-base-dev libeigen3-dev libsuitesparse-dev liblapacke-dev \
    libgdcm2-dev \
    xvfb \
    && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    abi-compliance-checker gcc-4.6 g++-4.6 ctags \
    && \
  rm -rf /var/lib/apt/lists/*
