#!/bin/bash -e
{ # force bash to read file completelly
DIR=$1
IMAGE_NAME=$2

. /app/deploy/env.sh
. /app/images/$IMAGE_NAME/tools/env.sh

PACKAGE_BASE_DIR=/opt/build-worker/packages/plaidml-ubuntu16.04

set +x
set +u
python3 -m venv /home/build/plaidml-venv
source /home/build/plaidml-venv/bin/activate

set -u
set -x

if [ -z "${PLAIDML_VERSION}" ]; then
  PLAIDML_VERSION=$(ls -1 ${PACKAGE_BASE_DIR} | sort -r -V | head -1)
fi

python3 -m pip install ${PACKAGE_BASE_DIR}/${PLAIDML_VERSION}/plaidml2*.whl

echo "PlaidML: ${PLAIDML_VERSION}" >> /home/build/info.txt

cat >/home/build/.plaidml2 <<EOL
PLAIDML_DEVICE=llvm_cpu.0
PLAIDML_TARGET=llvm_cpu
EOL

rm -rf /home/build/.cache

echo "Done"
exit 0
}
