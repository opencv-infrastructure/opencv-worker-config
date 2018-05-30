FROM opencv-base:fedora28

RUN \
  dnf install -y \
    @development-tools \
    cmake ccache \
    python2 python2-devel python2-numpy \
    python3 python3-devel python3-numpy \
    zlib zlib-devel libjpeg-turbo libjpeg-turbo-devel libpng-devel libtiff-devel jasper-devel \
    gtk3-devel \
    ffmpeg-devel \
    ant ant-junit java-1.8.0-openjdk \
    hdf-devel \
    leptonica-devel tesseract-devel \
    libusb-devel \
    gdalcpp-devel \
    vtk-devel \
    glog-devel \
    atlas-devel \
    gdcm-devel \
    libgphoto2-devel \
    openni-devel \
    xorg-x11-server-Xvfb \
    ctags \
    && \
  dnf clean all
