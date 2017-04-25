FROM i386/ubuntu:16.04

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    software-properties-common \
    curl git htop man zip unzip vim wget ncdu mc nano time \
    && \
  rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/sh"]

CMD ["/app/deploy/entry.sh"]
