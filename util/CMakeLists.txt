
##############################
### Generate source files using makedefs ###
##############################

add_executable(makedefs makedefs.c ../src/monst.c ../src/objects.c)

file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/dat)
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/src)

# 1) From util folder
add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/include/date.h
    COMMAND $<TARGET_FILE:makedefs> -v
    DEPENDS makedefs
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/util
    COMMENT "Creating header file date.h (makedefs -v)"
)

add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/include/onames.h
    COMMAND $<TARGET_FILE:makedefs> -o
    DEPENDS makedefs
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/util
    COMMENT "Creating header file onames.h (makedefs -o)"
)

add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/include/pm.h
    COMMAND $<TARGET_FILE:makedefs> -p
    DEPENDS makedefs
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/util
    COMMENT "Creating header file pm.h (makedefs -p)"
)

add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/src/monstr.c
    COMMAND $<TARGET_FILE:makedefs> -m
    DEPENDS makedefs
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/util
    COMMENT "Creating source file monstr.c (makedefs -m)"
)

add_custom_command(
    OUTPUT 
      ${CMAKE_BINARY_DIR}/include/vis_tab.h 
      ${CMAKE_BINARY_DIR}/src/vis_tab.c
    COMMAND $<TARGET_FILE:makedefs> -z
    DEPENDS makedefs
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/util
    COMMENT "Creating vis_tab.h and vis_tab.c (makedefs -z)"
)

# 2) From dat folder

# data.base is needed by "makedefs -d"
configure_file(${CMAKE_SOURCE_DIR}/dat/data.base ${CMAKE_BINARY_DIR}/dat/data.base COPYONLY)
add_custom_command(
    OUTPUT 
      ${CMAKE_BINARY_DIR}/dat/data
    COMMAND $<TARGET_FILE:makedefs> -d
    DEPENDS 
      makedefs
      ${CMAKE_BINARY_DIR}/dat/data.base
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/dat
    COMMENT "Generating NetHack database (makedefs -d)"
)

configure_file(${CMAKE_SOURCE_DIR}/dat/rumors.tru ${CMAKE_BINARY_DIR}/dat/rumors.tru COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/dat/rumors.fal ${CMAKE_BINARY_DIR}/dat/rumors.fal COPYONLY)
add_custom_command(
    OUTPUT 
      ${CMAKE_BINARY_DIR}/dat/rumors
    COMMAND $<TARGET_FILE:makedefs> -r
    DEPENDS 
      makedefs
      ${CMAKE_BINARY_DIR}/dat/rumors.tru
      ${CMAKE_BINARY_DIR}/dat/rumors.fal
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/dat
    COMMENT "Generating rumors (makedefs -r)"
)

configure_file(${CMAKE_SOURCE_DIR}/dat/epitaph.txt ${CMAKE_BINARY_DIR}/dat/epitaph.txt COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/dat/engrave.txt ${CMAKE_BINARY_DIR}/dat/engrave.txt COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/dat/bogusmon.txt ${CMAKE_BINARY_DIR}/dat/bogusmon.txt COPYONLY)
add_custom_command(
    OUTPUT 
      ${CMAKE_BINARY_DIR}/dat/engrave
      ${CMAKE_BINARY_DIR}/dat/epitaph
      ${CMAKE_BINARY_DIR}/dat/bogusmon
    COMMAND $<TARGET_FILE:makedefs> -s
    DEPENDS 
      makedefs 
      ${CMAKE_BINARY_DIR}/dat/epitaph.txt
      ${CMAKE_BINARY_DIR}/dat/engrave.txt
      ${CMAKE_BINARY_DIR}/dat/bogusmon.txt
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/dat
    COMMENT "Generating ../dat/engrave, ../dat/epitaph, ../dat/bogusmon (makedefs -s)"
)

configure_file(${CMAKE_SOURCE_DIR}/dat/quest.txt ${CMAKE_BINARY_DIR}/dat/quest.txt COPYONLY)
add_custom_command(
    OUTPUT 
      ${CMAKE_BINARY_DIR}/dat/quest.dat
    COMMAND $<TARGET_FILE:makedefs> -q
    DEPENDS makedefs ${CMAKE_BINARY_DIR}/dat/quest.txt
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/dat
    COMMENT "Generating quests (makedefs -q)"
)

configure_file(${CMAKE_SOURCE_DIR}/dat/oracles.txt ${CMAKE_BINARY_DIR}/dat/oracles.txt COPYONLY)
add_custom_command(
    OUTPUT 
      ${CMAKE_BINARY_DIR}/dat/oracles
    COMMAND $<TARGET_FILE:makedefs> -h
    DEPENDS makedefs ${CMAKE_BINARY_DIR}/dat/oracles.txt
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/dat
    COMMENT "Generating oracles (makedefs -h)"
)

configure_file(${CMAKE_SOURCE_DIR}/dat/dungeon.def ${CMAKE_BINARY_DIR}/dat/dungeon.def COPYONLY)
add_custom_command(
    OUTPUT 
      ${CMAKE_BINARY_DIR}/dat/dungeon.pdf
    COMMAND $<TARGET_FILE:makedefs> -e
    DEPENDS makedefs ${CMAKE_BINARY_DIR}/dat/dungeon.def
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/dat
    COMMENT "Generating dungeon.pdf (makedefs -e)"
)

add_custom_target(GenerateCode ALL
    DEPENDS 
      ${CMAKE_BINARY_DIR}/include/date.h
      ${CMAKE_BINARY_DIR}/include/onames.h
      ${CMAKE_BINARY_DIR}/include/pm.h
      ${CMAKE_BINARY_DIR}/src/monstr.c
      ${CMAKE_BINARY_DIR}/include/vis_tab.h 
      ${CMAKE_BINARY_DIR}/src/vis_tab.c
      ${CMAKE_BINARY_DIR}/dat/data
      ${CMAKE_BINARY_DIR}/dat/rumors
      ${CMAKE_BINARY_DIR}/dat/engrave
      ${CMAKE_BINARY_DIR}/dat/epitaph
      ${CMAKE_BINARY_DIR}/dat/bogusmon
      ${CMAKE_BINARY_DIR}/dat/quest.dat
      ${CMAKE_BINARY_DIR}/dat/oracles
      ${CMAKE_BINARY_DIR}/dat/dungeon.pdf
    COMMENT "Checking if code generation is required"
)


#############
### uudecode ###
#############

add_executable(uudecode ../sys/share/uudecode.c)

add_custom_command(
  OUTPUT ${CMAKE_BINARY_DIR}/win/win32/nethack.ico
  COMMAND $<TARGET_FILE:uudecode> ${CMAKE_SOURCE_DIR}/sys/winnt/nhico.uu
  DEPENDS uudecode ${CMAKE_SOURCE_DIR}/sys/winnt/nhico.uu
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/win/win32
  COMMENT "decoding icon (nhico.uu to NetHack.ico)"
)

set(UUBMPS mnsel mnselcnt mnunsel petmark pilemark splash rip)
foreach(UUBMP ${UUBMPS})
	add_custom_command(
	  OUTPUT ${CMAKE_BINARY_DIR}/win/win32/${UUBMP}.bmp
	  COMMAND $<TARGET_FILE:uudecode> ${CMAKE_SOURCE_DIR}/win/win32/${UUBMP}.uu
	  DEPENDS uudecode ${CMAKE_SOURCE_DIR}/win/win32/${UUBMP}.uu
	  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/win/win32
	  COMMENT "decoding mnsel (${UUBMP}.uu to ${UUBMP}.bmp)"
	)
endforeach()

add_custom_command(
  OUTPUT ${CMAKE_BINARY_DIR}/win/win32/record
  COMMAND $<TARGET_FILE:uudecode> ${CMAKE_SOURCE_DIR}/win/win32/record.uu
  DEPENDS uudecode ${CMAKE_SOURCE_DIR}/win/win32/record.uu
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/win/win32
  COMMENT "decoding record (record.uu to record.)"
)

add_custom_target(DecodeData ALL
  DEPENDS
    ${CMAKE_BINARY_DIR}/win/win32/nethack.ico
    ${CMAKE_BINARY_DIR}/win/win32/mnselcnt.bmp
    ${CMAKE_BINARY_DIR}/win/win32/mnunsel.bmp
    ${CMAKE_BINARY_DIR}/win/win32/petmark.bmp
    ${CMAKE_BINARY_DIR}/win/win32/pilemark.bmp
    ${CMAKE_BINARY_DIR}/win/win32/splash.bmp
    ${CMAKE_BINARY_DIR}/win/win32/rip.bmp
    ${CMAKE_BINARY_DIR}/win/win32/record
  COMMENT "Checking if data decoding is required"
)
