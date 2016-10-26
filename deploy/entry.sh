#!/bin/bash -e

set -x

if [ -f /app/deploy/env.sh ]; then
  . /app/deploy/env.sh
fi

if [ -f /app/config/twistd.pid ]; then
  rm /app/config/twistd.pid
fi

if [ -f /.prepare_done ]; then
  echo "Preparation step have been done. Run 'docker exec -it <opencv-buildworker> rm /.prepare_done' to re-run it again"
else
  /app/deploy/prepare_root.sh || exit 1
  su - build -c /app/deploy/prepare.sh || exit 1
  touch /.prepare_done
fi

su - build -c "/app/deploy/launch.sh"
