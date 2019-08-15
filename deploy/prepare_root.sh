#!/bin/bash -ex

getent passwd build || {
  groupadd -r build -g $APP_GID
  useradd -u $APP_UID -r -g build -d /home/build -m -s /bin/bash -c "Build user" build
}
[ ! -e /var/run/docker.sock ] || {
  DOCKER_GID=$(stat -c "%g" /var/run/docker.sock)
  getent group docker_build || groupadd -o docker_build -g $DOCKER_GID
  usermod -aG docker_build build
}

chown build:build /home/build
[ ! -d /home/build/.ssh ] || chown -R build:build /home/build/.ssh

mkdir -p /env
chown -R build:build /env

mkdir -p /build
chown build:build /build /build/*

set -x

if [ -n "${BUILDWORKER_USE_BUILD_2}" ]; then  # controlled via env.sh
  mkdir -p /build-2
  chown build:build /build-2 /build-2/*
fi

if [ -n "${BUILDWORKER_USE_BUILD_3}" ]; then  # controlled via env.sh
  mkdir -p /build-3
  chown build:build /build-3 /build-3/*
fi
