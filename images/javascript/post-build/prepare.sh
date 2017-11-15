#!/bin/bash -e

DIR=$1

. /app/deploy/env.sh

# fetch files from host cache
mkdir -p /opt/build-containers-cache/nvm/.nvm
mkdir -p /opt/build-containers-cache/nvm-cache
mkdir -p /opt/build-containers-cache/javascript/.npm
rsync -axHAX --exclude .nvm/alias /opt/build-containers-cache/nvm/.nvm $HOME/
rsync -axHAX /opt/build-containers-cache/javascript/.npm $HOME/

${DIR}/scripts/install-nvm.sh
. ${HOME}/.nvm/nvm.sh # load nvm

# redefine NVM cache
nvm_cache_dir() {
  nvm_echo "/opt/build-containers-cache/nvm-cache"
}

NODEJS_VERSION=${NODEJS_VERSION:-"--lts"}
nvm install ${NODEJS_VERSION}
nvm use ${NODEJS_VERSION}
(
  set -x
  node --version
  npm --version
)

if [ -n "${NPM_REGISTRY_URL}" ]; then
  npm config set registry "${NPM_REGISTRY_URL}"
fi

npm install -g node-qunit

# update cache back
rsync -avxHAX --checksum --exclude .nvm/versions --exclude .nvm/alias $HOME/.nvm /opt/build-containers-cache/nvm
rsync -avxHAX --checksum --exclude .npm/_locks --exclude .npm/_logs $HOME/.npm /opt/build-containers-cache/javascript
