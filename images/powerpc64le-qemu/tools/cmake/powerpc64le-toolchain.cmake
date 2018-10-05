set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR powerpc64le)

set(CMAKE_C_COMPILER /usr/bin/powerpc64le-linux-gnu-gcc-7)
set(CMAKE_CXX_COMPILER /usr/bin/powerpc64le-linux-gnu-g++-7)

set(CMAKE_FIND_ROOT_PATH /usr/powerpc64le-linux-gnu)

if(EXISTS "${CMAKE_SOURCE_DIR}/modules/core")
  include("${CMAKE_SOURCE_DIR}/platforms/linux/gnu.toolchain.cmake")
else()
  # we are in try_compile case
endif()
