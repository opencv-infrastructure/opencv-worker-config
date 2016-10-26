FROM opencv-base:14.04

RUN \
  apt-get update && \
  apt-get install -y \
    python python-pip python-virtualenv python-twisted \
    openssh-client rsync \
    && \
  rm -rf /var/lib/apt/lists/*
