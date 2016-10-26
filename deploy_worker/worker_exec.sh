#!/bin/bash -e

JOB_ID=$1
shift
. $BASE_DIR/.container/job_$JOB_ID "$@"
