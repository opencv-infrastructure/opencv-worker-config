FROM ubuntu:20.04

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    software-properties-common \
    curl git zip unzip wget rsync mc nano time \
    file \
    && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    cmake \
    build-essential \
    ccache \
    ninja-build \
    python2-dev \
    python-numpy \
    python3-dev \
    python3-numpy \
    python3-setuptools \
    python3-pip \
    zlib1g-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff5-dev \
    libopenjp2-7-dev \
    libgtk-3-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libavresample-dev \
    ant \
    ant-optional \
    default-jdk \
    hdf5-tools \
    libhdf5-dev \
    liblept5 \
    tesseract-ocr \
    tesseract-ocr-eng \
    libtesseract-dev \
    libtesseract4 \
    libgdal-dev \
    libvtk7-dev \
    libgoogle-glog-dev \
    libatlas-base-dev \
    libeigen3-dev \
    libsuitesparse-dev \
    liblapacke-dev \
    libceres-dev \
    libeigen3-dev \
    libgtkglext1-dev \
    libopenni2-dev \
    libglfw3-dev \
    xvfb \
    pkg-config && \
  apt-get clean && python3 -m pip install --upgrade pip && pip install requests pylint==2.4.4 && pip cache purge

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
        gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-libav \
    libopenni2-dev \
    libdc1394-22-dev \
    libgphoto2-dev \
    && \
  mkdir /opencv /opencv-build /opencv-contrib-build && \
  rm -rf /var/lib/apt/lists/*

CMD bash
