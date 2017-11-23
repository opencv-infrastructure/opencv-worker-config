FROM opencv-base:17.10

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    cmake build-essential ccache \
    python-dev python-numpy \
    python3-dev python3-numpy \
    zlib1g-dev libjpeg-dev libpng-dev libtiff5-dev \
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
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
        gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-libav \
    libopenni2-dev \
    libdc1394-22-dev \
    libgphoto2-dev \
    && \
  rm -rf /var/lib/apt/lists/*
