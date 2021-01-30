#!/bin/bash -x

. /tools/env.sh

mkdir -p $EMSDK_DIR
cp -a ${EMSDK_CACHE_DIR}/* $EMSDK_DIR || true
chown -R build:build $EMSDK_DIR
[ -d ${EMSDK_CACHE_DIR}/clang ] && ln -sf ${EMSDK_CACHE_DIR}/clang $EMSDK_DIR/
[ -d ${EMSDK_CACHE_DIR}/emscripten ] && ln -sf ${EMSDK_CACHE_DIR}/emscripten $EMSDK_DIR/
[[ -d ${EMSDK_CACHE_DIR}/node && ! -e $EMSDK_DIR/node ]] && ln -sf ${EMSDK_CACHE_DIR}/node $EMSDK_DIR/

cp -a ${EMSDK_CACHE_DIR}/.home/.em* /home/build/ || true
chown build:build /home/build/.em* || true

exec su - build -c "bash -ex /tools/prepare.sh"
