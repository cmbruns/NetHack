project(Nethack)
cmake_minimum_required(VERSION 3.4)

include_directories(include)

file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/include)
include_directories(${CMAKE_BINARY_DIR}/include)

# Build makedefs first, before anything else
add_subdirectory(util)

configure_file(${CMAKE_SOURCE_DIR}/win/share/tilemap.c ${CMAKE_BINARY_DIR}/win/share/tiletxt.c COPYONLY)
