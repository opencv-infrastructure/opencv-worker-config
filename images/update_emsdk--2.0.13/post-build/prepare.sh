#!/bin/bash -e
{ # force bash to read file completelly
DIR=$1
IMAGE_NAME=${2?Missing image name}

. /app/deploy/env.sh
. /app/images/$IMAGE_NAME/tools/env.sh

export

EMSDK_DIR=/opt/build-worker/emsdk-${EMSDK_VERSION}

# fetch files from host cache
mkdir -p /opt/build-containers-cache/emsdk-${EMSDK_VERSION}/
mkdir -p ${EMSDK_DIR}
rsync -axHAX /opt/build-containers-cache/emsdk-${EMSDK_VERSION}/ ${EMSDK_DIR}/

pushd ${EMSDK_DIR}

set -x
git rev-parse HEAD || (rm -rf ./.git && git clone https://github.com/emscripten-core/emsdk .)
git reset --hard || true
git clean -f -d || true
git fetch origin
git checkout -B deploy ${EMSDK_GIT_TAG:-${EMSDK_VERSION}}
git rev-parse HEAD

# update git source cache back
rsync -avxHAX --delete --checksum ${EMSDK_DIR}/ /opt/build-containers-cache/emsdk-${EMSDK_VERSION}/

./emsdk list
./emsdk install ${EMSDK_VERSION}
./emsdk activate ${EMSDK_VERSION}
source ./emsdk_env.sh
export

mkdir -p ./.home
cp -rp ~/.em* ./.home/

popd

# update git source cache back
rsync -axHAX --delete --checksum ${EMSDK_DIR}/ /opt/build-containers-cache/emsdk-${EMSDK_VERSION}/
set +x

echo "Done"
exit 0
}
