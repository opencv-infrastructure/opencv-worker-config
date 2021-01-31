#!/bin/bash -e

if [ -f /app/deploy/env.sh ]; then
  . /app/deploy/env.sh
fi

if [ ! -f /env/bin/activate ]; then
  virtualenv --system-site-packages /env
  . /env/bin/activate
  pip install -U 'pip<21' wheel 'setuptools<45' six
else
  . /env/bin/activate
fi

set -x

(
cd /app/buildbot/slave
python setup.py develop
)

mkdir -p /build/logs
cp -rf /app/config/info /build/
[[ -d /build-2 ]] && cp -rf /app/config/info /build-2/
[[ -d /build-3 ]] && cp -rf /app/config/info /build-3/

chmod 700 ${HOME}/.ssh
chmod 600 ${HOME}/.ssh/*

git config --global user.name "build"
git config --global user.email "build@slave"

if [ -f /app/deploy/prepare-custom.sh ]; then
  . /app/deploy/prepare-custom.sh
fi
