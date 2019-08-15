#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <build dir>"
  exit 1
fi

BUILD_DIR=${1?Missing build dir}

DIR=${BUILD_DIR}/_repos
if [ ! -d "$DIR" ]; then
  DIR=$(pwd)
fi

echo "Builds base directory: ${BUILD_DIR}"
echo "Repositories base directory: ${DIR}"

(
  cd $DIR
  OPENCV_GIT_URL=${OPENCV_GIT_URL:-https://github.com/opencv}
  git clone --bare ${OPENCV_GIT_URL}/opencv.git || (cd opencv.git; git fetch origin)
  git clone --bare ${OPENCV_GIT_URL}/opencv_extra.git || (cd opencv_extra.git; git fetch origin)
  git clone --bare ${OPENCV_GIT_URL}/opencv_contrib.git || (cd opencv_contrib.git; git fetch origin)
)

pushd ${BUILD_DIR}

set +e

for d in *; do
  if [[ -d "$d" && $d != "_repos" && $d != "logs" && $d != "info" ]]; then
    echo "======================================= $d "
    cd $d
    if [[ $d == precommit* || $d == master* || $d == 2_4* || $d == *3_4* ]]; then
      (
      git clone -s -n ${DIR}/opencv.git
      git clone -s -n ${DIR}/opencv_extra.git
      git clone -s -n ${DIR}/opencv_contrib.git
      )
    fi
    if [[ $d == precommit* ]]; then
      (
      echo "    +2.4"
      mkdir -p 2.4; cd 2.4;
      git clone -s -n ${DIR}/opencv.git
      git clone -s -n ${DIR}/opencv_extra.git
      #git clone -s -n ${DIR}/opencv_contrib.git
      )
      (
      echo "    +3.4"
      mkdir -p 3.4; cd 3.4;
      git clone -s -n ${DIR}/opencv.git
      git clone -s -n ${DIR}/opencv_extra.git
      git clone -s -n ${DIR}/opencv_contrib.git
      )
    fi
    cd ..
  fi
done

popd

exit 0
