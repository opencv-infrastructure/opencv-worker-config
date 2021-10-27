#!/bin/bash -ex

pwd
export
export BUILD_DIR=$(basename "$BASE_DIR")

getent passwd build || {
  groupadd -r build -g $APP_GID
  useradd -u $APP_UID -r -g build -d /home/build -m -s /bin/bash -c "Build user" build
}
if [ -e /dev/dri/card0 ]; then
  VIDEO_GID=$(stat -c "%g" /dev/dri/card0)
  getent group video_build || groupadd -o video_build -g $VIDEO_GID
  usermod -aG video_build build
elif [ -e /dev/dri/controlD64 ]; then
  VIDEO_GID=$(stat -c "%g" /dev/dri/controlD64)
  getent group video_build || groupadd -o video_build -g $VIDEO_GID
  usermod -aG video_build build
fi

if [ -e /dev/dri/renderD128 ]; then
  RENDER_GID=$(stat -c "%g" /dev/dri/renderD128)
  getent group render_build || groupadd -o render_build -g $RENDER_GID
  usermod -aG render_build build
fi

chown build:build /home/build

/app/deploy/worker_prepare_root.sh

su - build -c "cd $BASE_DIR; . /app/deploy/worker_launch.sh"
