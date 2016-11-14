project(Nethack)
cmake_minimum_required(VERSION 3.4)

# Use generated include files in favor of in-source includes
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/include)
include_directories(${CMAKE_BINARY_DIR}/include)

include_directories(include)

# Build makedefs first, before anything else
add_subdirectory(util)

if (WIN32)
  configure_file(${CMAKE_SOURCE_DIR}/win/share/tilemap.c ${CMAKE_BINARY_DIR}/win/share/tiletxt.c COPYONLY)
  add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/win/win32/record
    COMMAND ${CMAKE_COMMAND} -E touch ${CMAKE_BINARY_DIR}/win/win32/record
    COMMENT "Creating record file"
  )
  add_custom_target(CheckRecordFile ALL
    DEPENDS ${CMAKE_BINARY_DIR}/win/win32/record
    COMMENT "Checking if record file exists"
  )
endif()
