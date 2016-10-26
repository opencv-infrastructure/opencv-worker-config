#!/bin/bash -ex

ldconfig

get_image_script()
{
  local docker_image=$1
  local image=$(echo $docker_image | sed 's/^opencv-//g' | sed 's/:/--/g')
  if [[ -n "$image" ]]; then
    local script_name="/app/deploy/images/prepare-$image"
    if [ -f "${script_name}" ]; then
      echo "${script_name}"
    fi
  else
    return 0
  fi
}

script_name=$(get_image_script all)
if [ -n "${script_name}" ]; then
  . "${script_name}" "$@"
fi

script_name=$(get_image_script $BUILD_IMAGE)
if [ -n "${script_name}" ]; then
  . "${script_name}" "$@"
fi

#[ ! -d /opt/arm-linux-gnueabihf ] || cp -rf /opt/arm-linux-gnueabihf/* /usr/arm-linux-gnueabihf/

#[ ! -d /opt/packages/ceres/build ] ||
#(
#  cd /opt/packages/ceres/build
#  make install || /bin/true
#)
