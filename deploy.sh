#!/bin/bash -el
cd "$( dirname "${BASH_SOURCE[0]}" )"

IMAGE=buildslave_image
CONTAINER=buildslave

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
time ./scripts/docker_build_images.sh images buildworker

(
  cd downloads
  [ -f docker.tgz ] || wget -O docker.tgz http://get.docker.com/builds/Linux/x86_64/docker-1.12.3.tgz
  echo "626601deb41d9706ac98da23f673af6c0d4631c4d194a677a9a1a07d7219fa0f  docker.tgz" | sha256sum -c -
  tar -xzf docker.tgz docker/docker
)

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
    -h linux-slave \\
    --memory 4g \\
    -v \${P}:/app \\
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
