#!/bin/bash -e
{ # force bash to read file completelly

# Container started with these mounted volumes:
# - /app
# - /opt
DIR=${1?Missing workdir}
IMAGE_NAME=${2?Missing image name}

# Grab build user UID/GID
if [ -f /app/deploy/env.sh ]; then
  . /app/deploy/env.sh
else
  echo "ERROR: env.sh is missing"
  exit 1
fi

if [ -f /.prepare_done ]; then
  echo "FATAL: container misusing detected"
  exit 1
fi

set -x

getent passwd build || {
  groupadd -r build -g $APP_GID
  useradd -u $APP_UID -r -g build -d /home/build -m -s /bin/bash -c "Build user" build
}
chown build:build /home/build
chown build:build /opt/build-containers-cache

if [ -x ${DIR}/prepare_root.sh ]; then
  ${DIR}/prepare_root.sh || exit 1
fi

su - build -c "${DIR}/prepare.sh \"${DIR}\" ${IMAGE_NAME}" 2>&1 | tee /tmp/container.log
exit $?
}
