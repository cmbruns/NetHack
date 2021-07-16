# Support project version
if (POLICY CMP0048)
  cmake_policy(SET CMP0048 NEW)
endif (POLICY CMP0048)

# Visual studio runtime library /MT not /MD
if (POLICY CMP0091)
  cmake_policy(SET CMP0091 NEW)
endif (POLICY CMP0091)

project(NetHack VERSION 3.6.6)

cmake_minimum_required(VERSION 3.20)

set(ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../..")

set(BIN_DIR "${ROOT_DIR}/bin")
set(INC_DIR "${ROOT_DIR}/include")
set(SRC_DIR "${ROOT_DIR}/src")
set(SYS_SHARE_DIR "${ROOT_DIR}/sys/share")
set(SYS_WINNT_DIR "${ROOT_DIR}/sys/winnt")
set(TOOLS_DIR "${ROOT_DIR}/tools")
set(UTIL_DIR "${ROOT_DIR}/util")
set(WIN_CURS_DIR "${ROOT_DIR}/win/curses")
set(WIN_SHARE_DIR "${ROOT_DIR}/win/share")
set(WIN_TTY_DIR "${ROOT_DIR}/win/tty")
set(WIN_WIN32_DIR "${ROOT_DIR}/win/win32")

include_directories("${INC_DIR}")

# Most targets are TOOLS, so set default output to tools dir
# Use the same output folder as win/win32/vs2017 solution, e.g. tools/Release/x64/
set(PLATFORM "$<$<EQUAL:4,${CMAKE_SIZEOF_VOID_P}>:win32>$<$<EQUAL:8,${CMAKE_SIZEOF_VOID_P}>:x64>")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${TOOLS_DIR}/Release/${PLATFORM}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${TOOLS_DIR}/Debug/${PLATFORM}")

add_compile_definitions(WIN32CON DLB MSWIN_GRAPHICS)

set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# TODO wrap more tools and use them to build all the nethack stuff
include(dgncomp)

include(nethackdll)

message("${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")

add_custom_command(
    TARGET NetHackDLL POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/nhvr.py $<TARGET_FILE_DIR:NetHackDLL>/nhvr.py
    COMMENT "Copying nhvr.py to $<TARGET_FILE_DIR:NetHackDLL>"
    # DEPFILE ${CMAKE_CURRENT_SOURCE_DIR}/nhvr.py
    # BYPRODUCTS ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/nhvr.py
)

# configure_file(${CMAKE_CURRENT_SOURCE_DIR}/nhvr.py ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/nhvr.py COPYONLY)
