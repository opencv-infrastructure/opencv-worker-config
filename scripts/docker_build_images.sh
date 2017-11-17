#!/bin/bash -el
IMAGES_DIR=$1
ROOT_DIR=`cd "$1"/.. && pwd`
shift

if type "proxy_setup" 2>/dev/null; then
  proxy_setup
fi
#if [ -n "$HTTP_PROXY" ]; then
#  DOCKER_BUILD_ARGS="$DOCKER_BUILD_ARGS --build-arg HTTP_PROXY=$HTTP_PROXY"
#  DOCKER_BUILD_ARGS="$DOCKER_BUILD_ARGS --build-arg http_proxy=$HTTP_PROXY"
#fi
if [ -n "$HTTPS_PROXY" ]; then
  DOCKER_BUILD_ARGS="$DOCKER_BUILD_ARGS --build-arg HTTPS_PROXY=$HTTPS_PROXY"
  DOCKER_BUILD_ARGS="$DOCKER_BUILD_ARGS --build-arg https_proxy=$HTTPS_PROXY"
fi

if [ -n "$NOCACHE" ]; then
  DOCKER_BUILD_ARGS="--no-cache $DOCKER_BUILD_ARGS"
fi
# Doesn't work, because intermediate images are not pushed into registry
#if [ -z "$FAST" ]; then
#  DOCKER_BUILD_ARGS="--pull $DOCKER_BUILD_ARGS"
#fi

PROCESSED_IMAGES=()

containsElement () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

check_dependency()
{
  local docker_image=$1
  local image=$(echo $docker_image | sed 's/^opencv-//g' | sed 's/:/--/g')
  containsElement $docker_image "${PROCESSED_IMAGES[@]}" ||
  {
    echo "Required dependency: $image ($docker_image)"
    build_image $image
  }
}

build_image()
{
  local image=$1
  local docker_image=$(echo opencv-$image | sed 's/--/:/g')
  local image=$(echo $docker_image | sed 's/^opencv-//g' | sed 's/:/--/g')
  echo "Preparing image: $docker_image ($image)"
  local deps=$(head -n1 $IMAGES_DIR/$image/docker/Dockerfile | sed -E 's/FROM +//g')
  if [[ "${deps}" == opencv-* ]]; then
    echo "Deps: $deps"
    check_dependency $deps
  fi
  (
    echo "Processing image: $docker_image ($image)"
    cd $IMAGES_DIR/$image/docker
    if [ -d ../post-build ]; then
      time docker build $DOCKER_BUILD_ARGS -t staging-$docker_image .
      echo "Docker build completed at $(date '+%Y-%m-%d %H:%M:%S'): $docker_image ($image)"
      (
      set -x
      CONTAINER_NAME="preparing-$docker_image"
      CONTAINER_NAME=${CONTAINER_NAME//[^A-Za-z0-9._-]/_}
      WORKDIR=/app/images/$image/post-build
      docker rm ${CONTAINER_NAME} || /bin/true
      time docker run -it --name ${CONTAINER_NAME} \
          -v ${ROOT_DIR}:/app:ro \
          -v /opt/build-worker:/opt/build-worker:ro \
          -v /opt/build-containers-cache:/opt/build-containers-cache:rw \
          -v /opt/android:/opt/android:ro \
          staging-$docker_image \
          ${WORKDIR}/entry.sh "${WORKDIR}" "$image"
      time docker commit ${CONTAINER_NAME} $docker_image
      docker rm ${CONTAINER_NAME} || /bin/true
      docker rmi --no-prune staging-$docker_image || /bin/true
      )
      echo "Done at $(date '+%Y-%m-%d %H:%M:%S'): $docker_image ($image)"
    else
      time docker build $DOCKER_BUILD_ARGS -t $docker_image .
      echo "Done at $(date '+%Y-%m-%d %H:%M:%S'): $docker_image ($image)"
    fi
  )
  PROCESSED_IMAGES+=("$docker_image")
}

if [ "$#" -ge 1 ]; then
  echo "Build images: $*"
  for image in $*; do
    build_image $image
  done
else
  echo "Build images from: $IMAGES_DIR"
  for image in $IMAGES_DIR/*; do
    if [ -d $image ]; then
      build_image $(basename "$image")
    fi
  done
fi
echo "Done: $(date)"
