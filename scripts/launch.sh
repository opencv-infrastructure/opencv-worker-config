#!/bin/bash -e
echo "Launched: $(date) PID: $$"

mkdir -p /build/logs

[ -d /build/_repos ] ||
{
  mkdir -p /build/_repos
  (
    cd /build/_repos; /opt/build/scripts/build_clone_repositories.sh /build
  )
}

. /opt/pythonenv/bin/activate
. scripts/profile.sh

if [ -n "$http_proxy" ]; then
  git config --global http.proxy $http_proxy
fi

mkdir -p /Users/build/bin
[ ! -f /Users/build/bin/buildenv ] || rm -f /Users/build/bin/buildenv
ln $(pwd)/scripts/buildenv /Users/build/bin/buildenv
export PATH=/Users/build/bin:$PATH

cd config
buildslave --verbose start --nodaemon
