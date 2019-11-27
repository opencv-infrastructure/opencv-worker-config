#!/bin/bash -e
{ # force bash to read file completelly
DIR=$1
IMAGE_NAME=$2

. /app/deploy/env.sh
. /app/images/$IMAGE_NAME/tools/env.sh

set -u

CACHE_SPACE_NAME=plaidml
CACHE_BASE_DIR=/opt/build-containers-cache/${CACHE_SPACE_NAME}

PACKAGE_BASE_DIR=/opt/build-worker/packages/plaidml-ubuntu16.04
mkdir -p ${PACKAGE_BASE_DIR}

DOWNLOADS_CACHE_DIR=/opt/build-containers-cache/downloads
mkdir -p ${DOWNLOADS_CACHE_DIR}


# fetch files from host cache
mkdir -p ${CACHE_BASE_DIR}/.git
mkdir -p /home/build/sources/plaidml/
rsync -axHAX ${CACHE_BASE_DIR}/.git /home/build/sources/plaidml/

mkdir -p /home/build/.cache
mkdir -p ${CACHE_BASE_DIR}/.cache/pip
ln -s ${CACHE_BASE_DIR}/.cache/pip /home/build/.cache/pip
mkdir -p ${CACHE_BASE_DIR}/.cache/bazel
ln -s ${CACHE_BASE_DIR}/.cache/bazel /home/build/.cache/bazel
mkdir -p ${CACHE_BASE_DIR}/.cache/bazelisk
ln -s ${CACHE_BASE_DIR}/.cache/bazelisk /home/build/.cache/bazelisk

mkdir -p ${CACHE_BASE_DIR}/miniconda/pkgs


if [ ! -f ${DOWNLOADS_CACHE_DIR}/Miniconda3-${MINICONDA_VER}-Linux-x86_64.sh ]; then
  (
  cd ${DOWNLOADS_CACHE_DIR}
  wget https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VER}-Linux-x86_64.sh
  chmod +x Miniconda3-${MINICONDA_VER}-Linux-x86_64.sh
  # https://docs.conda.io/en/latest/miniconda_hashes.html
  echo "${MINICONDA_SHA256}  Miniconda3-${MINICONDA_VER}-Linux-x86_64.sh" | sha256sum -c
  )
fi

cat >/home/build/.condarc <<EOL
pkgs_dirs:
   - ${CACHE_BASE_DIR}/miniconda/pkgs
EOL

${DOWNLOADS_CACHE_DIR}/Miniconda3-${MINICONDA_VER}-Linux-x86_64.sh -b -p /home/build/miniconda

export PATH=/home/build/miniconda/condabin:$PATH

pushd /home/build/sources/plaidml

set -x
git describe --tags || (rm -rf ./.git && git clone https://github.com/plaidml/plaidml.git .)
git reset --hard || true
git clean -f -d || true
git fetch origin
git checkout -B master origin/master
DESCRIBE=`git describe --tags`
echo "PlaidML version: ${DESCRIBE}"

# update git source cache back
rsync -avxHAX --delete --checksum /home/build/sources/plaidml/.git ${CACHE_BASE_DIR}/

yes | python3 ./configure
bazelisk build //plaidml2:wheel

echo "PlaidML build: DONE"

ls -al bazel-bin/plaidml2/wheel.pkg/tmp/dist/*

mkdir -p ${PACKAGE_BASE_DIR}/${DESCRIBE}
cp -f bazel-bin/plaidml2/wheel.pkg/tmp/dist/plaidml2*.whl ${PACKAGE_BASE_DIR}/${DESCRIBE}/
echo "PlaidML package location: ${PACKAGE_BASE_DIR}/${DESCRIBE}/"

# Verify
set +x
set +u
python3 -m venv /home/build/plaidml-venv
source /home/build/plaidml-venv/bin/activate

set -x
python3 -m pip install bazel-bin/plaidml2/wheel.pkg/tmp/dist/plaidml2*.whl

popd

echo "Done"
exit 0
}
