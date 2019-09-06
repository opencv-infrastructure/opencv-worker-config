#!/bin/bash -ex

ldconfig

get_image_script()
{
  local image=$1
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

script_name="/tools/prepare_root.sh"
if [ -f "${script_name}" ]; then
  . "${script_name}" "$@"
  exit $?
fi
