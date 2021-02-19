#!/bin/bash -e

if [ "$(id -u)" == 0 ]; then
  echo "Unexpected root user".
  exit 1
fi

export

python2 -m virtualenv /opt/pythonenv
. /opt/pythonenv/bin/activate

python -m pip install --upgrade pip wheel 'setuptools<45' six
# doesn't work (OpenCV doesn't use virtualenv): python -m pip install numpy

cd /opt/build
(
cd buildbot/slave
pip install -e .
)

. /opt/build/deploy/env.sh

cp -rf /opt/build/config/info /build/
[[ -d /build-2 ]] && cp -rf /opt/build/config/info /build-2/
[[ -d /build-3 ]] && cp -rf /opt/build/config/info /build-3/

mkdir -p /build/_repos
(
  cd /build/_repos
  /opt/build/scripts/build_clone_repositories.sh /build || true
  [ -d /build-2 ] && /opt/build/scripts/build_clone_repositories.sh /build-2 || true
  [ -d /build-3 ] && /opt/build/scripts/build_clone_repositories.sh /build-3 || true
)

# CMake finds Python via Framework. Make a link for homebrew's python@2 package.
[ -d ${HOME}/Library/Frameworks/Python.framework ] ||
{
  mkdir -p ${HOME}/Library/Frameworks/
  list=( /usr/local/Cellar/python@2/2.7* )
  python_framework="${list[${#list[@]}-1]}"
  ln -s ${python_framework}/Frameworks/Python.framework ${HOME}/Library/Frameworks/
}

echo "Deploy: done"
exit 0
