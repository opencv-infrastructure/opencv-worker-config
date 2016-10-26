#!/bin/bash -e
if [ "$(id -u)" == 0 ]; then
  echo "Unexpected root user".
  exit 1
fi

# "docker exec" setup PATH env with "sbin" directories
export PATH=/app/bin:/usr/local/bin:/usr/bin:/bin
# there are issues with ldconfig for OpenCL libraries
export LD_LIBRARY_PATH=/opt/intel/opencl/:${LD_LIBRARY_PATH}
# restore missing USER
export USER=build # $(whoami)

JOB_ID=$1
echo $$ > $BASE_DIR/.container/job_${JOB_ID}_PID

(/app/deploy/worker_exec.sh "$@")
STATUS=$?
echo "$STATUS" > $BASE_DIR/.container/job_${JOB_ID}_status

rm -f $BASE_DIR/.container/job_${JOB_ID}_PID

exit $STATUS
