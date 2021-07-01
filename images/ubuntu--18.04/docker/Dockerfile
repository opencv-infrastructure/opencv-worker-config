ARG DOCKER_IMAGE_PREFIX
FROM ${DOCKER_IMAGE_PREFIX}base:18.04

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    cmake build-essential ccache ninja-build \
    python-dev python-numpy \
    python3-dev python3-numpy \
    zlib1g-dev libjpeg-dev libpng-dev libtiff5-dev libopenjp2-7-dev \
    libgtk2.0-dev \
    libavcodec-dev libavformat-dev libswscale-dev \
    libtbb-dev libtbb2 \
    ant ant-optional default-jdk \
    hdf5-tools libhdf5-dev \
    libleptonica-dev liblept5 tesseract-ocr tesseract-ocr-eng libtesseract-dev libtesseract4 \
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
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libva-dev \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
        gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-libav \
    libopenni2-dev \
    libdc1394-22-dev \
    libgphoto2-dev \
    && \
  rm -rf /var/lib/apt/lists/*

RUN \
  wget -O /tmp/abi-compliance-checker-2.3.tar.gz https://github.com/lvc/abi-compliance-checker/archive/2.3.tar.gz && \
  echo "b1e32a484211ec05d7f265ab4d2c1c52dcdb610708cb3f74d8aaeb7fe9685d64 /tmp/abi-compliance-checker-2.3.tar.gz" | sha256sum -c && \
  mkdir -p /opt/ && cd /opt/ && \
  tar -xf /tmp/abi-compliance-checker-2.3.tar.gz && \
  cd abi-compliance-checker-2.3/ && \
  chmod +x abi-compliance-checker.pl
