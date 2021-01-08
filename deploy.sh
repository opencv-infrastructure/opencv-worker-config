#!/bin/bash -el
cd "$( dirname "${BASH_SOURCE[0]}" )"

IMAGE=${IMAGE:-buildworker_image}
CONTAINER=${CONTAINER:-opencv-buildworker}

# Settings
if [ ! -f deploy/env.sh ]; then
  cat > deploy/env.sh <<EOF
export APP_UID=$UID
export APP_GID=$GROUPS

export BUILDBOT_MASTER_HOST=192.168.0.XXX
export BUILDBOT_MASTER_PORT=9989
export BUILDBOT_SLAVE_NAME=linux-slave-x64
export BUILDBOT_SLAVE_PASS=XXX

export ADB_HOST=XXX.XXX.XXX.XXX
export ADB_PORT=5037
EOF
fi

# Docker image
if [ -n "${BUILD_IMAGE:-}" ]; then
  time ./scripts/docker_build_images.sh images buildworker
elif PULLONLY=1 ./scripts/docker_build_images.sh images buildworker ; then
  echo "*"
  echo "* WARNING: Docker image is pulled from the registry. To re-build image locally run 'PUSH_IMAGE=1 BUILD_IMAGE=1 $0' to update/push the image."
  echo "*"
else
  echo "*"
  echo "* WARNING: Unable to pull image from the registry. Building it locally..."
  echo "*"
  time ./scripts/docker_build_images.sh images buildworker
fi

( # download static build of docker binaries
  cd downloads
  DOCKER_VERSION=20.10.2
  DOCKER_BINARY_SHA256="893e0b05e347dee1d857022181831c6ec3798e9a49fda9a319b2f5a6fb79c42d"
  DOCKER_ARCHIVE_SHA256="97017e32a8ecbdd1826bb3c7b1424303ee0dea3f900d33591b1df5e394ed4eed"
  echo "Checking docker binary (client, ${DOCKER_VERSION})..."
  if [ -f docker/docker ]; then
    if ! echo "${DOCKER_BINARY_SHA256}  docker/docker" | sha256sum -c - ; then
      echo "Invalid docker binary SHA256. Renaming binary to docker.save..."
      mv docker/docker{,.save} || rm docker/docker
    fi
  fi
  if [[ ! -x docker/docker ]]; then
    echo "Need to download docker binary..."
    if [ -f docker-${DOCKER_VERSION}.tgz ]; then
      if ! echo "${DOCKER_ARCHIVE_SHA256}  docker-${DOCKER_VERSION}.tgz" | sha256sum -c - ; then
        echo "Invalid/broken docker archive. Renaming to *.old ..."
        mv docker-${DOCKER_VERSION}.tgz{,.old} || rm docker-${DOCKER_VERSION}.tgz
      fi
    fi
    if [ ! -f docker-${DOCKER_VERSION}.tgz ]; then
      echo "Downloading docker static binaries (${DOCKER_VERSION}) ..."
      wget -O docker-${DOCKER_VERSION}.tgz https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz
      echo "${DOCKER_ARCHIVE_SHA256}  docker-${DOCKER_VERSION}.tgz" | sha256sum -c -
    fi
    tar -xzf docker-${DOCKER_VERSION}.tgz docker/docker
    echo "Checking extracted docker binary SHA256..."
    echo "${DOCKER_BINARY_SHA256}  docker/docker" | sha256sum -c - || exit 1
    echo "Checking extracted docker binary SHA256... OK"
  fi
) || exit 1

if [ ! -f .create.sh ]; then
cat > .create.sh <<EOF
#!/bin/bash

P=$(pwd)
CONTAINER=${CONTAINER}
IMAGE=${IMAGE}

docker stop \${CONTAINER}
docker rm \${CONTAINER}
docker run -it \\
    --name \${CONTAINER} \\
    -h linux-worker \\
    --memory 4g \\
    -v \${P}:/app \\
    -v /var/run/docker.sock:/run/docker.sock \\
    -v \${P}/downloads/docker/docker:/usr/local/bin/docker:ro \\
    -v /build:/build \\
    -v /data:/data \\
    -v /data-2:/data-2 \\
    -v /data-3:/data-3 \\
    -v /opt:/opt:ro \\
    -v /sys/fs/cgroup:/sys/fs/cgroup:rw \\
    \${IMAGE}
EOF
chmod +x .create.sh
fi

echo
echo "================================"
echo "1) Check settings in deploy/env.sh"
echo "2) Check and run .create.sh"
