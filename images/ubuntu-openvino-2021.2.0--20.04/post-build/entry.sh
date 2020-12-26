#!/bin/bash -e

# Container started with these mounted volumes:
# - /app
# - /opt
DIR=${1?Missing workdir}
IMAGE_NAME=${2?Missing image name}

# Install steps (root)
/opt/build-worker/intel-openvino/l_openvino_toolkit_p_2021.2.185/install.sh -s ${DIR}/silent.cfg

echo "Completed"
exit 0
