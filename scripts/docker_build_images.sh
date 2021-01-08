#!/bin/bash -el
{ # force bash to read file completelly
set -e
set -o pipefail
set -u

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ ! -n "${CONFIGURATION_SCRIPT:-}" ]; then
  CFG_FILES="${SCRIPT_DIR}/config.d/*.sh"
  for script in ${CFG_FILES}; do
    . "${script}"
  done
else
  . "${CONFIGURATION_SCRIPT}"
fi

# bash 4.4+ is OK: https://stackoverflow.com/questions/7577052/bash-empty-array-expansion-with-set-u
if ! echo $BASH_VERSION | awk -F. '{ if ($1 > 4 || ($1 == 4 && $2 >= 4)) { exit 0 } else {exit 1} }' ; then
  set +u
fi

function handle_stop() {
    echo ">>>>>>>> STOP <<<<<<<<"
    STOP_SIGNAL=1
}

trap handle_stop SIGINT SIGTERM

IMAGES_DIR=$1
ROOT_DIR=`cd "$1"/.. && pwd`
shift

DOCKER_IMAGE_PREFIX=${DOCKER_IMAGE_PREFIX:-opencv-}
DOCKER_CACHE_INFO_DIR=$(cd "${IMAGES_DIR}" && pwd)/.cache

if type "proxy_setup" >/dev/null 2>&1; then
  proxy_setup
fi
HTTP_PROXY=${HTTP_PROXY:-${http_proxy:-}}
DOCKER_BUILD_ARGS="${DOCKER_BUILD_ARGS:-} --build-arg HTTP_PROXY=$HTTP_PROXY --build-arg http_proxy=$HTTP_PROXY"
HTTPS_PROXY=${HTTPS_PROXY:-${https_proxy:-}}
DOCKER_BUILD_ARGS="$DOCKER_BUILD_ARGS --build-arg HTTPS_PROXY=$HTTPS_PROXY --build-arg https_proxy=$HTTPS_PROXY"
NO_PROXY=${NO_PROXY:-${no_proxy:-}}
DOCKER_BUILD_ARGS="$DOCKER_BUILD_ARGS --build-arg NO_PROXY=$NO_PROXY --build-arg no_proxy=$NO_PROXY"

if [ -n "${NOCACHE:-}" ]; then
  DOCKER_BUILD_ARGS="--no-cache $DOCKER_BUILD_ARGS"
fi
# Doesn't work, because intermediate images are not pushed into registry (until PUSH_IMAGE is used, but this doesn't make sence)
# Pull base images, like ubuntu:20.4 manually
#if [[ -z "${FAST:-}" ]]; then
#  DOCKER_BUILD_ARGS="--pull $DOCKER_BUILD_ARGS"
#fi

DOCKER_BUILD_ARGS="$DOCKER_BUILD_ARGS --build-arg DOCKER_IMAGE_PREFIX=$DOCKER_IMAGE_PREFIX"

PROCESSED_IMAGES=()
FAILED_IMAGES=()


YELLOW=`tput setaf 11 2>/dev/null || echo ""`
BOLD=`tput bold 2>/dev/null || echo ""`
ERROR_STYLE=`tput setaf 15 2>/dev/null || echo ""``tput setab 1 2>/dev/null || echo ""`$BOLD
RESET=`tput sgr0 2>/dev/null || echo ""`

exec 9>&1
execute()
{
  echo $BOLD$YELLOW$*$RESET 1>&9
  [[ "${DRY_RUN:-}" > 0 ]] || {
    /usr/bin/time $* || {
      RC=$?; echo "  "$ERROR_STYLE"result=$RC"$RESET 1>&9; return $RC
    }
  }
}


containsElement () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

check_dependency()
{
  local docker_image=$1
  local image=$(echo "${docker_image/#${DOCKER_IMAGE_PREFIX}/}" | sed 's/:/--/g' || true)
  containsElement $docker_image "${FAILED_IMAGES[@]}" && return 1 || /bin/true
  containsElement $docker_image "${PROCESSED_IMAGES[@]}" ||
  {
    echo "Required dependency: $image ($docker_image)"
    build_image $image || return 1
  }
}

build_image()
{
  local image=$1
  local docker_image=${DOCKER_IMAGE_PREFIX}$(echo $image | sed 's/--/:/g')
  local image=$(echo "${docker_image/#${DOCKER_IMAGE_PREFIX}/}" | sed 's/:/--/g' || true)
  echo "Preparing image: $docker_image ($image)"
  if [ ! -d "$IMAGES_DIR/$image" ]; then
    echo $ERROR_STYLE"... NOT FOUND"$RESET
    FAILED_IMAGES+=("$docker_image")
    return 1
  fi
  if [ -f $IMAGES_DIR/$image/alias ]; then
    local aliased_image=$(head -n1 $IMAGES_DIR/$image/alias)
    local docker_aliased_image=${DOCKER_IMAGE_PREFIX}$(echo $aliased_image | sed 's/--/:/g')
    echo "Aliased image: ${image} => ${aliased_image}"
    build_image $aliased_image || {
      echo "*  FATAL: Failed build of aliased image: ${image} => ${aliased_image}";
      FAILED_IMAGES+=("$docker_image")
      return 1
    }
    execute docker tag "${docker_aliased_image}" "${docker_image}"
    echo "Done at $(date '+%Y-%m-%d %H:%M:%S'): Aliased image: ${image} => ${aliased_image}"
    push_image_to_registry "${image}"
    return 0
  fi
  containsElement $docker_image "${PROCESSED_IMAGES[@]}" &&
  {
    echo "... already done."
    return 0
  }
  PROCESSED_IMAGES+=("$docker_image")

  if [ ! -r $IMAGES_DIR/$image/docker/Dockerfile ]; then
    echo $ERROR_STYLE"... mising Dockerfile"$RESET
    FAILED_IMAGES+=("$docker_image")
    return 1
  fi

  if [[ -n "${PULLONLY:-}" ]]; then
    execute docker pull $docker_image || {
      echo "*  FATAL: Failed to pull image: ${image} => ${aliased_image} ( $docker_image )";
      FAILED_IMAGES+=("$docker_image")
      return 1
    }
    return 0
  fi

  local deps=$(grep -E '^FROM' $IMAGES_DIR/$image/docker/Dockerfile | head -n1 | sed -E 's/FROM +//g')
  if [[ "${deps}" == opencv-* ]]; then  # legacy
    deps=${DOCKER_IMAGE_PREFIX}${deps/#opencv-/}
    echo "Deps: $deps"
    check_dependency $deps ||
    {
      FAILED_IMAGES+=("$docker_image")
      return 1
    }
  elif [[ "${deps}" == \$\{DOCKER_IMAGE_PREFIX\}* ]]; then
    deps=${DOCKER_IMAGE_PREFIX}${deps/#\$\{DOCKER_IMAGE_PREFIX\}/}
    echo "Deps: $deps"
    check_dependency $deps ||
    {
      FAILED_IMAGES+=("$docker_image")
      return 1
    }
  fi

  (
    echo "Processing image: $docker_image ($image)"
    cd $IMAGES_DIR/$image/docker
    if [ -d ../post-build ]; then
      HASH_POST_BUILD=$(tar -cf - -C ../post-build . | sha256sum -b | cut -d ' ' -f 1)
      echo "${docker_image}: Post-build scripts hash: ${HASH_POST_BUILD}"
      # TODO: other dirs, like /tools with env versions settings

      IMAGE_STAGING=staging-$docker_image
      execute docker build $DOCKER_BUILD_ARGS -t ${IMAGE_STAGING} . ||
      {
        echo "==============================================================================="
        echo "*  FATAL: Can't build staging image: $docker_image ($image)"
        echo "==============================================================================="
        exit 1
      }
      echo "Docker staging build completed at $(date '+%Y-%m-%d %H:%M:%S'): $docker_image ($image)"
      HASH_DOCKER_IMAGE_STAGING=$(docker inspect --type=image --format='{{index .Id}}' ${IMAGE_STAGING} | cut -d ':' -f 2)
      (
      set -e
      WORKDIR=/app/images/$image/post-build
      DOCKER_ARGS=(
-v ${ROOT_DIR}:/app:ro
-v /opt/build-worker:/opt/build-worker:rw
-v /opt/build-containers-cache:/opt/build-containers-cache:rw
-v /opt/android:/opt/android:ro
${DOCKER_RUN_ARGS:-}
${IMAGE_STAGING}
"${WORKDIR}/entry.sh" "${WORKDIR}" "$image"
)
      HASH_DOCKER_ARGS=$(echo "${DOCKER_ARGS[@]}" | sed -e s~${ROOT_DIR}~ROOT_DIR~g | sha256sum | cut -d ' ' -f 1)

      CACHE_FILE_NAME="${DOCKER_CACHE_INFO_DIR}/${image}.info"
      if [[ ! -n "${NOCACHE:-}" && -f "${CACHE_FILE_NAME}" ]]; then
        echo "${docker_image}: Checking cache..."
        CACHE_IMAGE_ID=($(cat "${CACHE_FILE_NAME}"))
        if [[ "${CACHE_IMAGE_ID[1]}" == "${HASH_POST_BUILD}" &&
              "${CACHE_IMAGE_ID[2]}" == "${HASH_DOCKER_IMAGE_STAGING}" &&
              "${CACHE_IMAGE_ID[3]}" == "${HASH_DOCKER_ARGS}" ]]; then
          echo "${docker_image}: Image cache candidate: ${CACHE_IMAGE_ID}"
          if docker image inspect "${CACHE_IMAGE_ID}" >/dev/null 2>&1 ; then
            (
              execute docker tag ${CACHE_IMAGE_ID} $docker_image || exit 1
              docker rmi --no-prune ${IMAGE_STAGING} || /bin/true
            ) && exit 0 || /bin/true
          else
            echo "${docker_image}:     Image cache candidate is not available"
          fi
        else
            echo "${docker_image}: Cache miss"
        fi
      fi

      CONTAINER_NAME="preparing-$docker_image"
      CONTAINER_NAME=${CONTAINER_NAME//[^A-Za-z0-9._-]/_}
      docker inspect ${CONTAINER_NAME} >/dev/null 2>&1 && docker rm ${CONTAINER_NAME} || /bin/true
      execute docker run -it --name ${CONTAINER_NAME} ${DOCKER_ARGS[@]} || exit 1

      STATUS=`docker inspect ${CONTAINER_NAME} --format='{{.State.ExitCode}}' || echo 1`
      if [[ $STATUS != 0 ]]; then
        echo "==============================================================================="
        echo "*  FATAL: Post-build step failed for image: $docker_image ($image)"
        echo "==============================================================================="
        exit 1
      fi
      execute docker commit ${CONTAINER_NAME} $docker_image || exit 1
      docker rm ${CONTAINER_NAME} || /bin/true
      docker rmi --no-prune ${IMAGE_STAGING} || /bin/true

      HASH_DOCKER_IMAGE=$(docker inspect --type=image --format='{{index .Id}}' $docker_image | cut -d ':' -f 2)
      mkdir -p ${DOCKER_CACHE_INFO_DIR} || /bin/true
      echo "${HASH_DOCKER_IMAGE} ${HASH_POST_BUILD} ${HASH_DOCKER_IMAGE_STAGING} ${HASH_DOCKER_ARGS}" > "${CACHE_FILE_NAME}" ||
          echo "WARNING: Can't update image cache info"
      ) || exit 1
      echo "Done at $(date '+%Y-%m-%d %H:%M:%S'): $docker_image ($image)"
    else
      execute docker build $DOCKER_BUILD_ARGS -t $docker_image . ||
      {
        echo "==============================================================================="
        echo "*  FATAL: Can't build image: $docker_image ($image)"
        echo "==============================================================================="
        exit 1
      }
      echo "Done at $(date '+%Y-%m-%d %H:%M:%S'): $docker_image ($image)"
    fi
  ) ||
  {
    FAILED_IMAGES+=("$docker_image")
    return 1
  }
  push_image_to_registry "${image}"
}

push_image_to_registry()
{
  local image=$1
  local docker_image=${DOCKER_IMAGE_PREFIX}$(echo $image | sed 's/--/:/g')
  if [ -n "${PUSH_IMAGE:-}" ]; then
    local docker_push_image=${DOCKER_PUSH_IMAGE_PREFIX:-DOCKER_IMAGE_PREFIX}$(echo $image | sed 's/--/:/g')
    execute docker tag "${docker_image}" "${docker_push_image}"
    execute docker push "${docker_push_image}" ||
    {
      echo "==============================================================================="
      echo "*  FATAL: Can't push docker image: $docker_push_image ($image)"
      echo "*       : Ensure to call 'docker login'"
      echo "==============================================================================="
      exit 1
    }
    execute docker rmi "${docker_push_image}"
  fi
}

if [ "$#" -ge 1 ]; then
  echo "Build images: $*"
  for image in $*; do
    build_image $image || /bin/true
    if [ -n "${STOP_SIGNAL:-}" ]; then
      break
    fi
  done
else
  echo "Build images from: $IMAGES_DIR"
  IMAGES_TO_SKIP=( test )
  for cfg in $IMAGES_DIR/.images_skip_auto_build*; do
    echo "... reading: $cfg"
    readarray lines < "$cfg"
    IMAGES_TO_SKIP+=(${lines[@]})
  done
  for image in $IMAGES_DIR/*; do
    BASENAME=$(basename "$image")
    containsElement "$BASENAME" "${IMAGES_TO_SKIP[@]}" && continue
    if [ -d $image ]; then
      if [[ ! -f "$image/.image_skip_auto_build" || -f "$image/.image_force_build" ]]; then
        build_image "$BASENAME" || /bin/true
      fi
    fi
    if [ -n "${STOP_SIGNAL:-}" ]; then
      break
    fi
  done
fi
echo $RESET"==============================================================================="
for image in ${FAILED_IMAGES[@]}; do
  echo $ERROR_STYLE"Failed image: $image"$RESET
done
if [ ${#FAILED_IMAGES[@]} -gt 0 ]; then
  echo "FAILED"
  exit 1
fi
echo "Done: $(date)"

exit 0
} # force bash to read file completelly
