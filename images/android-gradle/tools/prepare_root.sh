#!/bin/bash -x

mkdir -p /build/.cache/${BUILD_DIR}-${BUILD_IMAGE}/.android
chown build:build /build/.cache/${BUILD_DIR}-${BUILD_IMAGE}/.android
ln -s /build/.cache/${BUILD_DIR}-${BUILD_IMAGE}/.android /home/build/.android

mkdir -p /build/.cache/${BUILD_DIR}-${BUILD_IMAGE}/.gradle
chown build:build /build/.cache/${BUILD_DIR}-${BUILD_IMAGE}/.gradle
ln -s /build/.cache/${BUILD_DIR}-${BUILD_IMAGE}/.gradle /home/build/.gradle

exit 0
