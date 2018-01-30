#!/bin/bash -ex

getent passwd build || {
  groupadd -r build -g $APP_GID
  useradd -u $APP_UID -r -g build -d /home/build -m -s /bin/bash -c "Build user" build
}
if [ -e /dev/dri/controlD64 ]; then
  VIDEO_GID=$(stat -c "%g" /dev/dri/controlD64)
  getent group video_build || groupadd -o video_build -g $VIDEO_GID
  usermod -aG video_build build
elif [ -e /dev/dri/renderD128 ]; then
  VIDEO_GID=$(stat -c "%g" /dev/dri/renderD128)
  getent group video_build || groupadd -o video_build -g $VIDEO_GID
  usermod -aG video_build build
fi

chown build:build /home/build

/app/deploy/worker_prepare_root.sh

su - build -c "cd $BASE_DIR; . /app/deploy/worker_launch.sh"
