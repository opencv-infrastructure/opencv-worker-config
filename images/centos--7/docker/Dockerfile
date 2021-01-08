ARG DOCKER_IMAGE_PREFIX
FROM ${DOCKER_IMAGE_PREFIX}base:centos7

RUN \
  yum update -y && \
  yum groupinstall -y 'Development Tools' && \
  yum install -y --setopt=skip_missing_names_on_install=False \
    cmake3 ccache \
    python python-devel numpy \
    zlib zlib-devel libjpeg-turbo libjpeg-turbo-devel libpng12 libpng12-devel libtiff-devel jasper-devel \
    gtk2-devel \
    ant ant-junit java-1.6.0-openjdk-devel \
    hdf5-devel \
    leptonica-devel tesseract-devel \
    libusb-devel \
    gdal-devel \
    vtk-devel \
    glog-devel \
    atlas-devel eigen3-devel \
    xorg-x11-server-Xvfb.x86_64 \
    ctags \
    && \
  yum clean all

# No replacements:
#    libavformat-dev libavformat-extra-54 libswscale-dev \
#    libgdcm2-dev \
