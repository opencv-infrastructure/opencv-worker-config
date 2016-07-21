#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <build dir>"
  exit 1
fi

DIR=$(pwd)
git clone --bare git://github.com/opencv/opencv.git
git clone --bare git://github.com/opencv/opencv_extra.git
git clone --bare git://github.com/opencv/opencv_contrib.git

pushd ${1}

for d in ./*; do
  if [[ -d "$d" ]] && [[ $d != "_repos" ]] && [[ $d != *logs ]] && [[ $d != *info ]]; then
    echo $d
    cd $d
    git clone -s -n ${DIR}/opencv.git
    git clone -s -n ${DIR}/opencv_extra.git
    git clone -s -n ${DIR}/opencv_contrib.git
    if [[ $d == *precommit* ]] || [[ $d == *2_4* ]]; then
      (
      echo "    +2.4"
      mkdir -p 2.4; cd 2.4;
      git clone -s -n ${DIR}/opencv.git
      git clone -s -n ${DIR}/opencv_extra.git
      git clone -s -n ${DIR}/opencv_contrib.git
      )
    fi
    cd ..
  fi
done

popd
