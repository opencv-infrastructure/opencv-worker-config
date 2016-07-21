#!/bin/bash -ex

/usr/bin/groups build || {
  groupadd -r build -g $APP_GID
  useradd -u $APP_UID -r -g build -d /home/build -m -s /bin/bash -c "Build user" build
}

mkdir -p /env
chown -R build:build /env

mkdir -p /build
chown -R build:build /build
mkdir -p /build-2
chown -R build:build /build-2
mkdir -p /build-3
chown -R build:build /build-3

cp -rf /opt/arm-linux-gnueabihf/* /usr/arm-linux-gnueabihf/

(
  cd /opt/packages/ceres/build
  make install || /bin/true
)
