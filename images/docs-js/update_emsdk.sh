#!/bin/bash -xe
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker run -it --rm --name opencv-emsdk-update \
    -v /opt/build-worker:/opt/build-worker:rw \
    -v /opt/build-worker/emsdk:/opt/emsdk-portable:rw \
    -v ${DIR}/update_emsdk:/app/deploy:ro \
    opencv-docs-js
