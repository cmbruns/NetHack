project(Nethack)
cmake_minimum_required(VERSION 3.4)

# Use generated include files in favor of in-source includes
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/include)
include_directories(${CMAKE_BINARY_DIR}/include)

if (MSVC)
  include_directories(${CMAKE_SOURCE_DIR}/sys/winnt)
endif()

include_directories(include)

# Build makedefs first, before anything else
add_subdirectory(util)

add_subdirectory(src)
