#!/bin/bash -e
{ # force bash to read file completelly
DIR=$1

. /app/deploy/env.sh

# fetch files from host cache
mkdir -p /opt/build-containers-cache/onnxruntime/.git
mkdir -p /home/build/sources/onnxruntime/
rsync -axHAX /opt/build-containers-cache/onnxruntime/.git /home/build/sources/onnxruntime/

pushd /home/build/sources/onnxruntime

set -x
git describe || (rm -rf ./.git && git clone --recursive https://github.com/microsoft/onnxruntime.git .)
git reset --hard || true
git clean -f -d || true
git fetch origin || true
git checkout -B test v1.5.1 #origin/master
git submodule sync --recursive
git submodule update --init --recursive
git status
DESCRIBE=`git describe`
echo "ONNX Runtime: ${DESCRIBE}"

# update git source cache back
rsync -avxHAX --delete --checksum /home/build/sources/onnxruntime/.git /opt/build-containers-cache/onnxruntime/


python3 ./tools/ci_build/build.py --build_dir `pwd`/build --config Release --build_shared_lib --skip_tests --parallel --cmake_generator Ninja --target install --cmake_extra_defines CMAKE_INSTALL_PREFIX=/opt/onnxrt

popd

rm -rf /home/build/sources/onnxruntime/.git
rm -rf /home/build/sources/onnxruntime

echo "Done"
exit 0
}
