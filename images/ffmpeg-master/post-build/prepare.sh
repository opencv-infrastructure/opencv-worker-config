#!/bin/bash -e
{ # force bash to read file completelly
DIR=$1

. /app/deploy/env.sh

# fetch files from host cache
mkdir -p /opt/build-containers-cache/ffmpeg/.git
mkdir -p /home/build/sources/ffmpeg/
rsync -axHAX /opt/build-containers-cache/ffmpeg/.git /home/build/sources/ffmpeg/

pushd /home/build/sources/ffmpeg

set -x
git describe || (rm -rf ./.git && git clone https://github.com/FFmpeg/FFmpeg.git .)
git reset --hard || true
git clean -f -d || true
git fetch origin
git checkout -B master n4.0.2 #origin/master
DESCRIBE=`git describe`
echo "FFmpeg: ${DESCRIBE}"

# update git source cache back
rsync -avxHAX --delete --checksum /home/build/sources/ffmpeg/.git /opt/build-containers-cache/ffmpeg/

./configure --prefix=/opt/ffmpeg --enable-avresample \
  --enable-pic --disable-asm --disable-debug \
  --disable-cuda --disable-cuvid \
  --disable-ffmpeg \
|| (./configure --help; false)

make install -j5

popd

rm -rf /home/build/sources/ffmpeg/.git

echo "Done"
exit 0
}
