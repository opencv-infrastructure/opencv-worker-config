#!/bin/bash -x
docker stop $(docker ps --filter name="opencv_build_*" -q 2>/dev/null) 2>/dev/null
sleep 2
docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
docker rm -v $(docker ps --filter name="opencv_build_*" --filter status=created -q 2>/dev/null) 2>/dev/null
docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
