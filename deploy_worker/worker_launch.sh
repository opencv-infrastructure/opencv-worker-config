#!/bin/bash -ex
BASE_DIR=$PWD

id
echo 1 > $BASE_DIR/.container/Initialized
exec sleep 172800 # 48h
