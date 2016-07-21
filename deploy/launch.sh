#!/bin/bash

. /app/deploy/env.sh
. /app/deploy/profile.sh

. /env/bin/activate
umask 0000

cd /build/_repos
/app/scripts/build_clone_repositories.sh /build
[ -d /build-2 ] && /app/scripts/build_clone_repositories.sh /build-2
[ -d /build-3 ] && /app/scripts/build_clone_repositories.sh /build-3

cd /app/config
if [ -z "$DEBUG" ]; then
  buildslave start --nodaemon
else
  python /app/deploy/run_debug.py --verbose start --nodaemon
fi
