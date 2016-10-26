#!/bin/bash

if [ -f /app/deploy/env.sh ]; then
  . /app/deploy/env.sh
fi

virtualenv --system-site-packages /env
. /env/bin/activate

set -x

pip install pyOpenSSL

(
cd /app/buildbot/slave
python setup.py develop
)

mkdir /build/logs
cp -rf /app/config/info /build/
[[ -d /build-2 ]] && cp -rf /app/config/info /build-2/
[[ -d /build-3 ]] && cp -rf /app/config/info /build-3/

mkdir -p /build/_repos
cd /build/_repos
/app/scripts/build_clone_repositories.sh /build

chmod 700 ${HOME}/.ssh
chmod 600 ${HOME}/.ssh/*

git config --global user.name "build"
git config --global user.email "build@slave"
