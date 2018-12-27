FROM opencv-base:16.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    cmake build-essential \
    doxygen doxygen-latex graphviz python-sphinx texlive-full \
    && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    p7zip-full \
    && \
  rm -rf /var/lib/apt/lists/*

RUN \
  wget https://sourceforge.net/projects/doxygen/files/rel-1.8.12/doxygen-1.8.12.linux.bin.tar.gz && \
  echo "295e2fcd74a5c6ec46188958ab495e61  doxygen-1.8.12.linux.bin.tar.gz" > md5sum -c - && \
  mkdir -p /opt/doxygen && tar -xzf doxygen-1.8.12.linux.bin.tar.gz -C /opt/doxygen && \
  rm -f doxygen-1.8.12.linux.bin.tar.gz

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    pylint \
    && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    python-bs4 \
    python3-bs4 \
    && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    ant ant-optional default-jdk \
    && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    flake8 \
    && \
  rm -rf /var/lib/apt/lists/*
