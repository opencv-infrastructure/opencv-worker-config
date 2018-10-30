#!/bin/bash -e

# Container started with these mounted volumes:
# - /app
# - /opt
DIR=${1?Missing workdir}
IMAGE_NAME=${2?Missing image name}

# Install steps (root)
mkdir /opt/vulkan_sdk
# https://sdk.lunarg.com/sdk/download/1.1.85.0/linux/vulkansdk-linux-x86_64-1.1.85.0.tar.gz
(cd /opt/vulkan_sdk; tar -xf /opt/build-worker/vulkan/vulkansdk-linux-x86_64-1.1.85.0.tar.gz; ls -al)

echo "Completed"
exit 0
