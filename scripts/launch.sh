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
. deploy/env.sh

if [ -n "$http_proxy" ]; then
  git config --global http.proxy $http_proxy
fi

# buildenv script path
export PATH=$(pwd)/bin:$PATH

cd config
buildslave --verbose start --nodaemon
