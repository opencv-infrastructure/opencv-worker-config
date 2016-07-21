#!/bin/bash -e

cgcreate -a build:build -t build:build -g memory:/build_buildenv
echo 4G > /sys/fs/cgroup/memory/build_buildenv/memory.limit_in_bytes
