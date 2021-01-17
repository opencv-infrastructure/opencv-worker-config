mkdir -p /app/logs

if [ ! -n "${CONFIGURATION_SCRIPT:-}" ]; then
  load_configuration()
  {
    local SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    local CFG_FILES="${SCRIPT_DIR}/config.d/*.sh"
    for script in ${CFG_FILES}; do
      . "${script}"
    done
  }
  load_configuration
else
  . "${CONFIGURATION_SCRIPT}"
fi

DOCKER=${DOCKER:-docker}
DOCKER_IMAGE_PREFIX=${DOCKER_IMAGE_PREFIX:-opencv-}

opencv_worker_container_cleanup()
{
  local WORK_DIR=${1:-$PWD}

  echo "cleanup:"$(printf " '%q'" "$@") >> /app/logs/container.logs

  local DOCKER_CONTAINER=$(cat $WORK_DIR/.container/ID)
  echo "cleanup container: $DOCKER_CONTAINER" >> /app/logs/container.logs

  # FIXIT ID file is writable by unsecure code
  $DOCKER stop "$DOCKER_CONTAINER" > /dev/null 2>&1 || true
  $DOCKER rm "$DOCKER_CONTAINER" > /dev/null 2>&1 || true
  rm -rf $WORK_DIR/.container || true
}

opencv_worker_container_create()
{
  local BUILD_IMAGE=$1
  local DOCKER_IMAGE=${DOCKER_IMAGE_PREFIX}$(echo ${BUILD_IMAGE} | sed 's/--/:/g')
  local WORK_DIR=$PWD

  date >> /app/logs/container.logs
  echo "create:"$(printf " '%q'" "$@") >> /app/logs/container.logs

  [ ! -f $WORK_DIR/.container/ID ] || {
    opencv_worker_container_cleanup "$WORK_DIR"
  }
  set -e

  mkdir -p $WORK_DIR/.container

  if [[ -f "/app/images/${BUILD_IMAGE}/.image_disallow" ]]; then
    echo "FATAL: Build image '${BUILD_IMAGE}' is not allowed on the current build worker" 1>&2
    return 1
  fi

  # Keep images up-to-date
  if [ ! -n "${DOCKER_SKIP_PULL:-}" ]; then
    # TODO: $DOCKER pull --quiet "${DOCKER_IMAGE}" || true
    $DOCKER pull "${DOCKER_IMAGE}" || true
  fi

  if [[ "$($DOCKER images -q ${DOCKER_IMAGE} 2> /dev/null)" == "" ]]; then
    echo "FATAL: Build image for '${BUILD_IMAGE}' is missing on the current build worker" 1>&2
    return 1
  fi

  local NAME="opencv_build_$(basename $WORK_DIR)_$$"

  DOCKER_OPTS="$DOCKER_OPTS --name $NAME"
  if [[ -z "${BUILD_BIGDATA}" ]]; then
    DOCKER_OPTS="$DOCKER_OPTS --memory 6G"
  fi
  DOCKER_OPTS="$DOCKER_OPTS --mount type=tmpfs,destination=/tmp,tmpfs-size=${DOCKER_TMPFS_SIZE-1073741824}"  # 1024MB
  . /app/scripts/container_options.sh
  DOCKER_OPTS="$DOCKER_OPTS -v $(host_mountpoint /app/deploy_worker):/app/deploy:ro"
  DOCKER_OPTS="$DOCKER_OPTS -v $(host_mountpoint /app/bin_worker):/app/bin:ro"
  if [[ -d /app/images/${BUILD_IMAGE}/tools ]]; then
    DOCKER_OPTS="$DOCKER_OPTS -v $(host_mountpoint /app/images/${BUILD_IMAGE}/tools):/tools:ro"
  fi
  DOCKER_OPTS="$DOCKER_OPTS -v $(host_mountpoint $WORK_DIR):$WORK_DIR:rw"
  DOCKER_OPTS="$DOCKER_OPTS --env BASE_DIR=$WORK_DIR"
  DOCKER_OPTS="$DOCKER_OPTS --env BUILD_IMAGE=$BUILD_IMAGE"
  DOCKER_OPTS="$DOCKER_OPTS --env APP_UID=$(id -u)"
  DOCKER_OPTS="$DOCKER_OPTS --env APP_GID=$(id -g)"

  # TODO DEBUG
  printf "%q " $DOCKER_OPTS > $WORK_DIR/.container/.options
  echo "" >> $WORK_DIR/.container/.options

  # Docker 1.13 will support --rm on server-side
  local DOCKER_CONTAINER=$($DOCKER run -d $DOCKER_OPTS $DOCKER_IMAGE /app/deploy/worker_entry.sh)
  echo "Container $NAME : $DOCKER_CONTAINER"
  echo "Container $NAME : $DOCKER_CONTAINER" >> /app/logs/container.logs
  echo $DOCKER_CONTAINER > $WORK_DIR/.container/ID
  local x=0 # timeout counter
  while [[ "$x" -lt 300 && ! -e $WORK_DIR/.container/Initialized ]]; do
    x=$((x+1))
    sleep .1
  done
  [ -e $WORK_DIR/.container/Initialized ]
}

opencv_worker_container_exec()
{
  local WORK_DIR=$PWD

  local BASE_DIR="$WORK_DIR"
  while true; do
    [[ -d $BASE_DIR && "$BASE_DIR" != "/" ]] || return 1
    [[ ! -d $BASE_DIR/.container ]] || break
    BASE_DIR=$(dirname $BASE_DIR)
  done

  local DOCKER_CONTAINER=$(cat $BASE_DIR/.container/ID)

  echo "$BASE_DIR exec:"$(printf " '%q'" "$@") >> /app/logs/container.logs

  JOB_FILE=$BASE_DIR/.container/job_$$
  export | grep -E '^declare \-x (BUILD_|OPENCV|PYTHON|JAVA|ANDROID|ADB|http_proxy|https_proxy|HTTPS_PROXY|VERBOSE)' > $JOB_FILE || true
  echo "cd $WORK_DIR" >> $JOB_FILE
  echo -n "/app/bin/buildenv " >> $JOB_FILE
  printf "%q " "$@" >> $JOB_FILE
  echo "" >> $JOB_FILE

  #DEBUG
  #cat $JOB_FILE

  # "docker exec" doesn't:
  # - terminate child processes automatically
  # - propagate exit code
  function docker_exec_cleanup {
    [ ! -f ${JOB_FILE}_PID ] || {
      CONTAINER_PID=$(cat ${JOB_FILE}_PID) && \
        $DOCKER exec --user build $DOCKER_CONTAINER kill -TERM -$CONTAINER_PID
    }
    kill $PID > /dev/null 2>&1 || true
  }
  trap "docker_exec_cleanup" TERM INT
  $DOCKER exec --user build $DOCKER_CONTAINER /app/deploy/worker_exec_wrap.sh $$ &
  PID=$!
  wait $PID
  trap - TERM INT
  wait $PID
  STATUS=$(cat ${JOB_FILE}_status || echo 1)
  return $STATUS
}

opencv_worker_container_dump_diff()
{
  local WORK_DIR=${1:-$PWD}

  echo "diff:"$(printf " '%q'" "$@") >> /app/logs/container.logs

  local DOCKER_CONTAINER=$(cat $WORK_DIR/.container/ID)
  echo "diff container: $DOCKER_CONTAINER" >> /app/logs/container.logs

  $DOCKER diff "$DOCKER_CONTAINER" || true
}
