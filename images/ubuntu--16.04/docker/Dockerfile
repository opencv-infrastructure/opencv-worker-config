ARG DOCKER_IMAGE_PREFIX
FROM ${DOCKER_IMAGE_PREFIX}base:16.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    cmake build-essential ccache ninja-build \
    python-dev python-numpy \
    python3-dev python3-numpy \
    zlib1g-dev libjpeg-dev libpng12-dev libtiff5-dev libjasper-dev libopenjp2-7-dev \
    libgtk2.0-dev \
    libavcodec-dev libavformat-dev libswscale-dev \
    libtbb-dev libtbb2 \
    ant ant-optional default-jdk \
    hdf5-tools libhdf5-dev \
    libleptonica-dev liblept5 tesseract-ocr tesseract-ocr-eng libtesseract-dev libtesseract3 \
    libusb-dev libusb-1.0.0-dev libudev-dev \
    libgdal-dev \
    libvtk6-dev \
    libgoogle-glog-dev \
    libatlas-base-dev libeigen3-dev libsuitesparse-dev liblapacke-dev \
    xvfb \
    && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libva-dev \
    && \
  rm -rf /var/lib/apt/lists/*

RUN \
  wget -O /tmp/abi-compliance-checker-2.3.tar.gz https://github.com/lvc/abi-compliance-checker/archive/2.3.tar.gz && \
  echo "b1e32a484211ec05d7f265ab4d2c1c52dcdb610708cb3f74d8aaeb7fe9685d64 /tmp/abi-compliance-checker-2.3.tar.gz" | sha256sum -c && \
  mkdir -p /opt/ && cd /opt/ && \
  tar -xf /tmp/abi-compliance-checker-2.3.tar.gz && \
  cd abi-compliance-checker-2.3/ && \
  chmod +x abi-compliance-checker.pl
