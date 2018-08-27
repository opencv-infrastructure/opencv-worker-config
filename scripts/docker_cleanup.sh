#!/bin/bash -x
docker stop $(docker ps --filter name="opencv_build_*" -q 2>/dev/null) 2>/dev/null
sleep 2

# remove containers
docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
docker rm -v $(docker ps --filter name="opencv_build_*" --filter status=created -q 2>/dev/null) 2>/dev/null

# Docker 1.25+
docker image prune --force --filter "until=24h"
#docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null

exit 0
