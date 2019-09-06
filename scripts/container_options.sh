get_image_script()
{
  local image=$1
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
