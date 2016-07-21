FROM ubuntu:14.04

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y \
    build-essential \
    software-properties-common \
    curl git htop man unzip vim wget ncdu mc nano time \
    && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  apt-get install -y \
    python python-dev python-pip python-virtualenv libpython2.7-dev libffi-dev python-twisted python-twisted-web \
    supervisor && \
  rm -rf /var/lib/apt/lists/*

RUN \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y \
    cmake build-essential \
    python-dev python-numpy \
    python3-dev python3-numpy \
    libncurses5:i386 libstdc++6:i386 zlib1g:i386 \
    zlib1g-dev libjpeg-dev libpng12-dev libtiff5-dev libjasper-dev \
    libgtk2.0-dev \
    libavformat-dev libavformat-extra-54 libswscale-dev \
    ant openjdk-7-jdk openjdk-7-jre \
    binutils-arm-linux-gnueabihf gcc-4.8-arm-linux-gnueabihf g++-4.8-arm-linux-gnueabihf pkg-config-arm-linux-gnueabihf \
    libtbb-dev libtbb2 \
    doxygen doxygen-latex graphviz \
    hdf5-tools hdf5-helpers libhdf5-7 libhdf5-dev libhdf5-serial-dev \
    libleptonica-dev liblept4 tesseract-ocr tesseract-ocr-eng libtesseract-dev libtesseract3 \
    libusb-dev libusb-1.0.0-dev libudev-dev \
    libgdal-dev \
    libvtk6-dev \
    libgoogle-glog-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev \
    abi-compliance-checker gcc-4.6 g++-4.6 \
    ccache \
    cgroup-bin \
    ncftp \
    xvfb \
    && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  apt-get install -y \
    valgrind zip lcov && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  apt-get install -y \
    liblapacke-dev && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  apt-get install -y \
    gcc-4.8-aarch64-linux-gnu \
    g++-4.8-aarch64-linux-gnu \
    binutils-aarch64-linux-gnu \
   && \
  rm -rf /var/lib/apt/lists/*

CMD ["/app/deploy/entry.sh"]
