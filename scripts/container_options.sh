get_image_script()
{
  local docker_image=$1
  local image=$(echo $docker_image | sed 's/^opencv-//g' | sed 's/:/--/g')
  if [[ -n "$image" ]]; then
    local script_name="/app/scripts/container_options-$image.sh"
    if [ -f "${script_name}" ]; then
      echo "${script_name}"
    fi
  else
    return 0
  fi
}

script_name=$(get_image_script $BUILD_IMAGE-pre)
if [ -n "${script_name}" ]; then
  . "${script_name}" "$@"
fi
script_name=$(get_image_script all)
if [ -n "${script_name}" ]; then
  . "${script_name}" "$@"
fi
script_name=$(get_image_script $BUILD_IMAGE)
if [ -n "${script_name}" ]; then
  . "${script_name}" "$@"
fi
