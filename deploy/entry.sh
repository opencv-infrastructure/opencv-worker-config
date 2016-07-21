#!/bin/bash -e

set -x

if [ -f /app/deploy/env.sh ]; then
  . /app/deploy/env.sh
fi

if [ -f /app/config/twistd.pid ]; then
  rm /app/config/twistd.pid
fi

if [ -f /app/deploy/.prepare_done ]; then
  echo "Preparation step have been done. Remove deploy/.prepare_done to run it again"
else
  /app/deploy/prepare_root.sh || exit 1
  su - build -c /app/deploy/prepare.sh || exit 1
  su - build -c "touch /app/deploy/.prepare_done"
fi

# build used is available here
/app/deploy/init_cgroups.sh

su - build -c "/app/deploy/launch.sh"
