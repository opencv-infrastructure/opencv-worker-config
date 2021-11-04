get_image_script()
{
  local image=$1
  local suffix=$2
  if [[ -n "$suffix" ]]; then
    suffix="-${suffix}"
  fi
  if [[ "${image}" == "${BUILD_IMAGE}" ]]; then
    local script_name="/app/images/${BUILD_IMAGE}/container_options$suffix.sh"
    if [ -f "${script_name}" ]; then
      echo "${script_name}"
      return 0
    fi
  fi
  local script_name="/app/scripts/container_options-$image$suffix.sh"
  if [ -f "${script_name}" ]; then
    echo "${script_name}"
    return 0
  fi
  return 0
}

script_name=$(get_image_script "worker_init")
if [ -n "${script_name}" ]; then
  . "${script_name}" "$@"
fi
script_name=$(get_image_script "$BUILD_IMAGE" "worker_pre")
if [ -n "${script_name}" ]; then
  . "${script_name}" "$@"
fi
script_name=$(get_image_script "$BUILD_IMAGE" "pre")
if [ -n "${script_name}" ]; then
  . "${script_name}" "$@"
fi
script_name=$(get_image_script "all" "")
if [ -n "${script_name}" ]; then
  . "${script_name}" "$@"
fi
script_name=$(get_image_script "$BUILD_IMAGE" "")
if [ -n "${script_name}" ]; then
  . "${script_name}" "$@"
fi
script_name=$(get_image_script "$BUILD_IMAGE" "worker_post")
if [ -n "${script_name}" ]; then
  . "${script_name}" "$@"
fi
script_name=$(get_image_script "worker_finalize")
if [ -n "${script_name}" ]; then
  . "${script_name}" "$@"
fi
