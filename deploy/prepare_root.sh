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
chown -R build:build /build
mkdir -p /build-2
chown -R build:build /build-2
mkdir -p /build-3
chown -R build:build /build-3

#[ ! -d /opt/arm-linux-gnueabihf ] || cp -rf /opt/arm-linux-gnueabihf/* /usr/arm-linux-gnueabihf/

#[ ! -d /opt/packages/ceres/build ] ||
#(
#  cd /opt/packages/ceres/build
#  make install || /bin/true
#)
