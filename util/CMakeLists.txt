
if (WIN32)
  configure_file(
    ${CMAKE_SOURCE_DIR}/win/share/tilemap.c 
    ${CMAKE_BINARY_DIR}/win/share/tiletxt.c 
    COPYONLY
  )
endif()

################
### uudecode ###
################

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
	  COMMENT "decoding ${UUBMP} (${UUBMP}.uu to ${UUBMP}.bmp)"
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

###########################
### levstuff & dgnstuff ###
###########################

if (yacc)
  message(SEND_ERROR "yacc rules not implemented")
else()
  message(STATUS "Using pre-built lev_yacc.c and lev_comp.h")
  configure_file(
    ${CMAKE_SOURCE_DIR}/sys/share/lev_yacc.c 
    ${CMAKE_BINARY_DIR}/util/lev_yacc.c
    COPYONLY
  )
  configure_file(
    ${CMAKE_SOURCE_DIR}/sys/share/lev_comp.h
    ${CMAKE_BINARY_DIR}/include/lev_comp.h
    COPYONLY
  )
  
  message(STATUS "Using pre-built dgn_yacc.c and dgn_comp.h")
  configure_file(
    ${CMAKE_SOURCE_DIR}/sys/share/dgn_yacc.c
    ${CMAKE_BINARY_DIR}/util/dgn_yacc.c
    COPYONLY
  )
  configure_file(
    ${CMAKE_SOURCE_DIR}/sys/share/dgn_comp.h
    ${CMAKE_BINARY_DIR}/include/dgn_comp.h
    COPYONLY
  )
endif()

if (lex)
  message(SEND_ERROR "lex rules not implemented")
else()
  message(STATUS "Using pre-built lev_lex.c")
  configure_file(
    ${CMAKE_SOURCE_DIR}/sys/share/lev_lex.c
    ${CMAKE_BINARY_DIR}/util/lev_lex.c
    COPYONLY
  )

  message(STATUS "Using pre-built dgn_lex.c")
  configure_file(
    ${CMAKE_SOURCE_DIR}/sys/share/dgn_lex.c
    ${CMAKE_BINARY_DIR}/util/dgn_lex.c
  )

endif()


###############
### recover ###
###############

add_executable(recover ${CMAKE_SOURCE_DIR}/util/recover.c)
install(TARGETS recover DESTINATION .)

################
### dlb_main ###
################

# Copy other files from source folder
foreach(THING tribute help hh cmdhelp history opthelp wizhelp license)
	configure_file(../dat/${THING} ${CMAKE_BINARY_DIR}/dat/${THING} COPYONLY)
endforeach()
if(MSVC)
foreach(THING porthelp)
	configure_file(../sys/winnt/${THING} ${CMAKE_BINARY_DIR}/dat/${THING} COPYONLY)
endforeach()
endif()

if (NETHACK_USE_DATA_LIBRARIAN)
	add_executable(dlb_main
	  ${CMAKE_SOURCE_DIR}/src/alloc.c
	  ${CMAKE_SOURCE_DIR}/src/dlb.c
	  ${CMAKE_SOURCE_DIR}/util/dlb_main.c
	  ${CMAKE_SOURCE_DIR}/util/panic.c
	)

	# create input file "dlb.lst" for dlb_main, used to create nhdat file
	#############
	#    echo data >dlb.lst
        #    echo oracles >>dlb.lst
        #    if exist options echo options >>dlb.lst
        #    if exist ttyoptions echo ttyoptions >>dlb.lst
        #    if exist guioptions echo guioptions >>dlb.lst
        #    if exist porthelp echo porthelp >>dlb.lst
        #    echo quest.dat >>dlb.lst
        #    echo rumors >>dlb.lst
        #    echo engrave >>dlb.lst
        #    echo epitaph >>dlb.lst
        #    echo bogusmon >>dlb.lst
        #    echo tribute >>dlb.lst
        #    echo help >>dlb.lst
        #    echo hh >>dlb.lst
        #    echo cmdhelp >>dlb.lst
        #    echo history >>dlb.lst
        #    echo opthelp >>dlb.lst
        #    echo wizhelp >>dlb.lst
        #    echo dungeon >>dlb.lst
        #    echo license >>dlb.lst
        #    for %%N in (*.lev) do echo %%N >>dlb.lst
	set(DLB_LIST_FILE ${CMAKE_BINARY_DIR}/dat/dlb.lst)
	file(WRITE ${DLB_LIST_FILE} "data \n")
	file(APPEND ${DLB_LIST_FILE} "oracles \n")
	foreach(THING options ttyoptions guioptions porthelp)
	if (EXISTS ${CMAKE_BINARY_DIR}/dat/${THING})
		file(APPEND ${DLB_LIST_FILE} "${THING} \n")
	endif()
	endforeach()
	foreach(THING quest.dat rumors engrave epitaph bogusmon tribute help 
				hh cmdhelp history opthelp wizhelp dungeon license)
		file(APPEND ${DLB_LIST_FILE} "${THING} \n")
	endforeach()
	file(GLOB LEV_FILES RELATIVE "${CMAKE_BINARY_DIR}/dat" "${CMAKE_CURRENT_BINARY_DIR}/../dat/*.lev")
	foreach(LEV_FILE ${LEV_FILES})
		# message(${LEV_FILE})
		file(APPEND ${DLB_LIST_FILE} "${LEV_FILE} \n")
	endforeach()
	
	add_custom_command(
	  OUTPUT ${STAGING_DIRECTORY}/nhdat
	  COMMAND dlb_main ARGS cIf dlb.lst ${STAGING_DIRECTORY}/nhdat
	  DEPENDS dlb_main
	  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/dat
	  COMMENT "Packaging nhdat via DLB"
	)

	add_custom_target(PackageDLB ALL
	  DEPENDS ${STAGING_DIRECTORY}/nhdat
	  COMMENT "Checking if DLB packaging is done"
	)
endif()

################
### tile2bmp ###
################

add_executable(tile2bmp
  ${CMAKE_SOURCE_DIR}/src/decl.c
  ${CMAKE_SOURCE_DIR}/src/drawing.c
  ${CMAKE_SOURCE_DIR}/src/monst.c
  ${CMAKE_SOURCE_DIR}/src/objects.c
  ${CMAKE_SOURCE_DIR}/win/share/tile2bmp.c
  ${CMAKE_SOURCE_DIR}/win/share/tiletext.c
  # tiletxt.c/tilemap.c is compiled twice, once with TILETEXT defined, and once without
  ${CMAKE_BINARY_DIR}/win/share/tiletxt.c
)
target_compile_definitions(tile2bmp PRIVATE TILETEXT=1)
