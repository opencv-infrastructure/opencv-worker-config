#!/bin/bash -x

EMSDK_DIR=/opt/emsdk-portable

mkdir -p $EMSDK_DIR
cp /opt/build-worker/emsdk/* $EMSDK_DIR || true
chown -R build:build $EMSDK_DIR
ln -sf /opt/build-worker/emsdk/clang $EMSDK_DIR/
ln -sf /opt/build-worker/emsdk/emscripten $EMSDK_DIR/
ln -sf /opt/build-worker/emsdk/node $EMSDK_DIR/

cp /opt/build-worker/emsdk/home/.em* /home/build/
chown build:build /home/build/.em*

exec su - build -c "bash -ex /tools/prepare.sh"
