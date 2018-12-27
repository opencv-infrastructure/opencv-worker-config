#!/bin/bash -x

. /tools/env.sh

mkdir -p $EMSDK_DIR
cp ${EMSDK_CACHE_DIR}/* $EMSDK_DIR || true
chown -R build:build $EMSDK_DIR
ln -sf ${EMSDK_CACHE_DIR}/clang $EMSDK_DIR/
ln -sf ${EMSDK_CACHE_DIR}/emscripten $EMSDK_DIR/
ln -sf ${EMSDK_CACHE_DIR}/node $EMSDK_DIR/

cp ${EMSDK_CACHE_DIR}/.home/.em* /home/build/
chown build:build /home/build/.em*

exec su - build -c "bash -ex /tools/prepare_user.sh"
