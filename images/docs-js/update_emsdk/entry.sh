#!/bin/bash -ex
OWNER=$(stat -c "%u:%g" /opt/emsdk-portable)
cd /opt/
tar -xf /opt/build-worker/emsdk/distrib/emsdk-portable.tar.gz
cd emsdk-portable
./emsdk update
./emsdk install latest
./emsdk activate latest
mkdir -p ./home
cp -rp ~/.em* ./home/
chown -R ${OWNER} /opt/emsdk-portable/
chmod -R go+rX /opt/emsdk-portable/
echo "Done"
