#!/bin/bash

mkdir /Users/build/bin
cp scripts/buildenv /Users/build/bin

cp -rf /opt/build/config/info /build/
[[ -d /build-2 ]] && cp -rf /opt/build/config/info /build-2/
[[ -d /build-3 ]] && cp -rf /opt/build/config/info /build-3/

mkdir -p /build/_repos
cd /build/_repos
/opt/build/scripts/build_clone_repositories.sh /build
[ -d /build-2 ] && /opt/build/scripts/build_clone_repositories.sh /build-2
[ -d /build-3 ] && /opt/build/scripts/build_clone_repositories.sh /build-3

cd /opt/build

# TODO configure automatic start:
# buildslave restart

