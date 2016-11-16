
if (WIN32)
  configure_file(
    ${CMAKE_SOURCE_DIR}/win/share/tilemap.c 
    ${CMAKE_BINARY_DIR}/win/share/tiletxt.c 
    COPYONLY
  )
endif()

############################################
### Generate source files using makedefs ###
############################################

add_executable(makedefs makedefs.c ../src/monst.c ../src/objects.c)

file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/dat)
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/src)

set(MAKEDEFS_OUTPUTS "")
function(run_makedefs flag subfolder depends)
  # Copy dependencies from source tree into build tree
  set(depends_bin "")
  foreach(DEPEND ${depends})
    configure_file(${CMAKE_SOURCE_DIR}/${DEPEND} ${CMAKE_BINARY_DIR}/${DEPEND} COPYONLY)
    set(depends_bin ${depends_bin} ${CMAKE_BINARY_DIR}/${DEPEND})
  endforeach()
  add_custom_command(
      OUTPUT ${ARGN}
      COMMAND $<TARGET_FILE:makedefs> -${flag}
      DEPENDS makedefs ${depends_bin}
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/${subfolder}
      COMMENT "Creating file(s) ${ARGN} (makedefs -${flag})"
  )
  set(MAKEDEFS_OUTPUTS ${MAKEDEFS_OUTPUTS} ${ARGN} PARENT_SCOPE)
endfunction()

run_makedefs(v util "" ${CMAKE_BINARY_DIR}/include/date.h)
run_makedefs(o util "" ${CMAKE_BINARY_DIR}/include/onames.h)
run_makedefs(p util "" ${CMAKE_BINARY_DIR}/include/pm.h)
run_makedefs(m util "" ${CMAKE_BINARY_DIR}/src/monstr.c)
run_makedefs(z util ""
  ${CMAKE_BINARY_DIR}/include/vis_tab.h
  ${CMAKE_BINARY_DIR}/src/vis_tab.c
)

# data.base is needed by "makedefs -d"
run_makedefs(d dat dat/data.base 
  ${CMAKE_BINARY_DIR}/dat/data)
run_makedefs(r dat 
  "dat/rumors.tru;dat/rumors.fal" # depends 
  ${CMAKE_BINARY_DIR}/dat/rumors) # output
run_makedefs(s dat 
  "dat/epitaph.txt;dat/engrave.txt;dat/bogusmon.txt" # depends 
  ${CMAKE_BINARY_DIR}/dat/engrave # output
  ${CMAKE_BINARY_DIR}/dat/epitaph
  ${CMAKE_BINARY_DIR}/dat/bogusmon
)
run_makedefs(q dat dat/quest.txt ${CMAKE_BINARY_DIR}/dat/quest.dat)
run_makedefs(h dat dat/oracles.txt ${CMAKE_BINARY_DIR}/dat/oracles)
run_makedefs(e dat dat/dungeon.def ${CMAKE_BINARY_DIR}/dat/dungeon.pdf)

add_custom_target(GenerateCode ALL
    DEPENDS ${MAKEDEFS_OUTPUTS}
    COMMENT "Checking if code generation is required"
)


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
### levcomp ###
###############

add_executable(levcomp
  ${CMAKE_SOURCE_DIR}/src/alloc.c
  ${CMAKE_SOURCE_DIR}/src/decl.c
  ${CMAKE_SOURCE_DIR}/src/drawing.c
  ${CMAKE_BINARY_DIR}/util/lev_lex.c
  lev_main.c
  ${CMAKE_BINARY_DIR}/util/lev_yacc.c
  ${CMAKE_SOURCE_DIR}/src/monst.c
  ${CMAKE_SOURCE_DIR}/src/objects.c
  panic.c
)

set(LEVCOMP_OUTPUTS "")
function(run_levcomp input_des)
  add_custom_command(
      OUTPUT ${ARGN}
      COMMAND $<TARGET_FILE:levcomp> ${CMAKE_SOURCE_DIR}/dat/${input_des}
      DEPENDS levcomp ${CMAKE_SOURCE_DIR}/dat/${input_des}
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/dat
      COMMENT "Building special levels from ${input_des}"
  )
  set(LEVCOMP_OUTPUTS ${LEVCOMP_OUTPUTS} ${ARGN} PARENT_SCOPE)
endfunction()

run_levcomp(Arch.des 
  ${CMAKE_BINARY_DIR}/dat/Arc-fila.lev
  ${CMAKE_BINARY_DIR}/dat/Arc-filb.lev
  ${CMAKE_BINARY_DIR}/dat/Arc-goal.lev
  ${CMAKE_BINARY_DIR}/dat/Arc-loca.lev
  ${CMAKE_BINARY_DIR}/dat/Arc-strt.lev
)
# TODO: enumerate other levels for each class
run_levcomp(Barb.des ${CMAKE_BINARY_DIR}/dat/Bar-goal.lev)
run_levcomp(Caveman.des ${CMAKE_BINARY_DIR}/dat/Cav-goal.lev)
run_levcomp(Healer.des ${CMAKE_BINARY_DIR}/dat/Hea-goal.lev)
run_levcomp(Knight.des ${CMAKE_BINARY_DIR}/dat/Kni-goal.lev)
run_levcomp(Monk.des ${CMAKE_BINARY_DIR}/dat/Mon-goal.lev)
run_levcomp(Priest.des ${CMAKE_BINARY_DIR}/dat/Pri-goal.lev)
run_levcomp(Ranger.des ${CMAKE_BINARY_DIR}/dat/Ran-goal.lev)
run_levcomp(Rogue.des ${CMAKE_BINARY_DIR}/dat/Rog-goal.lev)
run_levcomp(Samurai.des ${CMAKE_BINARY_DIR}/dat/Sam-goal.lev)
run_levcomp(Tourist.des ${CMAKE_BINARY_DIR}/dat/Tou-goal.lev)
run_levcomp(Valkyrie.des ${CMAKE_BINARY_DIR}/dat/Val-goal.lev)
run_levcomp(Wizard.des ${CMAKE_BINARY_DIR}/dat/Wiz-goal.lev)

run_levcomp(bigroom.des
  ${CMAKE_BINARY_DIR}/dat/bigrm-1.lev
  ${CMAKE_BINARY_DIR}/dat/bigrm-2.lev
  ${CMAKE_BINARY_DIR}/dat/bigrm-3.lev
  ${CMAKE_BINARY_DIR}/dat/bigrm-4.lev
  ${CMAKE_BINARY_DIR}/dat/bigrm-5.lev
  ${CMAKE_BINARY_DIR}/dat/bigrm-6.lev
  ${CMAKE_BINARY_DIR}/dat/bigrm-7.lev
  ${CMAKE_BINARY_DIR}/dat/bigrm-8.lev
  ${CMAKE_BINARY_DIR}/dat/bigrm-9.lev
  ${CMAKE_BINARY_DIR}/dat/bigrm-10.lev)
run_levcomp(castle.des
  ${CMAKE_BINARY_DIR}/dat/castle.lev)
run_levcomp(endgame.des
  ${CMAKE_BINARY_DIR}/dat/astral.lev
  ${CMAKE_BINARY_DIR}/dat/water.lev
  ${CMAKE_BINARY_DIR}/dat/fire.lev
  ${CMAKE_BINARY_DIR}/dat/air.lev
  ${CMAKE_BINARY_DIR}/dat/earth.lev)
run_levcomp(gehennom.des
  ${CMAKE_BINARY_DIR}/dat/sanctum.lev
  ${CMAKE_BINARY_DIR}/dat/baalz.lev
  ${CMAKE_BINARY_DIR}/dat/asmodeus.lev
  ${CMAKE_BINARY_DIR}/dat/orcus.lev
  ${CMAKE_BINARY_DIR}/dat/juiblex.lev
  ${CMAKE_BINARY_DIR}/dat/valley.lev)
run_levcomp(knox.des ${CMAKE_BINARY_DIR}/dat/knox.lev)
run_levcomp(medusa.des 
  ${CMAKE_BINARY_DIR}/dat/medusa-1.lev
  ${CMAKE_BINARY_DIR}/dat/medusa-2.lev
  ${CMAKE_BINARY_DIR}/dat/medusa-3.lev
  ${CMAKE_BINARY_DIR}/dat/medusa-4.lev
)
run_levcomp(mines.des 
  ${CMAKE_BINARY_DIR}/dat/minefill.lev
  ${CMAKE_BINARY_DIR}/dat/mineend-1.lev
  ${CMAKE_BINARY_DIR}/dat/mineend-2.lev
  ${CMAKE_BINARY_DIR}/dat/mineend-3.lev
  ${CMAKE_BINARY_DIR}/dat/minetn-1.lev
  ${CMAKE_BINARY_DIR}/dat/minetn-2.lev
  ${CMAKE_BINARY_DIR}/dat/minetn-3.lev
  ${CMAKE_BINARY_DIR}/dat/minetn-4.lev
  ${CMAKE_BINARY_DIR}/dat/minetn-5.lev
  ${CMAKE_BINARY_DIR}/dat/minetn-6.lev
  ${CMAKE_BINARY_DIR}/dat/minetn-7.lev
)
run_levcomp(oracle.des ${CMAKE_BINARY_DIR}/dat/oracle.lev)
run_levcomp(sokoban.des 
  ${CMAKE_BINARY_DIR}/dat/soko1-1.lev
  ${CMAKE_BINARY_DIR}/dat/soko1-2.lev
  ${CMAKE_BINARY_DIR}/dat/soko2-1.lev
  ${CMAKE_BINARY_DIR}/dat/soko2-2.lev
  ${CMAKE_BINARY_DIR}/dat/soko3-1.lev
  ${CMAKE_BINARY_DIR}/dat/soko3-2.lev
  ${CMAKE_BINARY_DIR}/dat/soko4-1.lev
  ${CMAKE_BINARY_DIR}/dat/soko4-2.lev
)
run_levcomp(tower.des 
  ${CMAKE_BINARY_DIR}/dat/tower1.lev
  ${CMAKE_BINARY_DIR}/dat/tower2.lev
  ${CMAKE_BINARY_DIR}/dat/tower3.lev
)
run_levcomp(yendor.des 
  ${CMAKE_BINARY_DIR}/dat/fakewiz1.lev
  ${CMAKE_BINARY_DIR}/dat/fakewiz2.lev
  ${CMAKE_BINARY_DIR}/dat/wizard1.lev
  ${CMAKE_BINARY_DIR}/dat/wizard2.lev
  ${CMAKE_BINARY_DIR}/dat/wizard3.lev
)

add_custom_target(BuildSpecialLevels ALL
    DEPENDS ${LEVCOMP_OUTPUTS}
    COMMENT "Checking if special levels are built"
)

###############
### dgncomp ###
###############

add_executable(dgncomp
  ${CMAKE_SOURCE_DIR}/src/alloc.c
  ${CMAKE_BINARY_DIR}/util/dgn_lex.c
  ${CMAKE_SOURCE_DIR}/util/dgn_main.c
  ${CMAKE_BINARY_DIR}/util/dgn_yacc.c
  ${CMAKE_SOURCE_DIR}/util/panic.c
)

add_custom_command(
  OUTPUT ${CMAKE_BINARY_DIR}/dat/dungeon
  COMMAND $<TARGET_FILE:dgncomp> dungeon.pdf
  DEPENDS dgncomp ${CMAKE_BINARY_DIR}/dat/dungeon.pdf
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/dat
  COMMENT "Building dungeon"
)

add_custom_target(BuildDungeon ALL
  DEPENDS ${CMAKE_BINARY_DIR}/dat/dungeon
  COMMENT "Checking if dungeon is built")

###############
### recover ###
###############

add_executable(recover ${CMAKE_SOURCE_DIR}/util/recover.c)
install(TARGETS recover DESTINATION .)

###############
### tilemap ###
###############

add_executable(tilemap ${CMAKE_SOURCE_DIR}/win/share/tilemap.c)
add_custom_command(
  OUTPUT ${CMAKE_BINARY_DIR}/src/tile.c
  COMMAND $<TARGET_FILE:tilemap>
  DEPENDS tilemap
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/src
  COMMENT "Generating src/tile.c"
)
add_custom_target(GenerateTileC
  DEPENDS ${CMAKE_BINARY_DIR}/src/tile.c
  COMMENT "Checking if tile.c is generated"
)

################
### dlb_main ###
################

if (NETHACK_USE_DATA_LIBRARIAN)
	add_executable(dlb_main
	  ${CMAKE_SOURCE_DIR}/src/alloc.c
	  ${CMAKE_SOURCE_DIR}/src/dlb.c
	  ${CMAKE_SOURCE_DIR}/util/dlb_main.c
	  ${CMAKE_SOURCE_DIR}/util/panic.c
	)

	add_custom_command(
	  OUTPUT ${CMAKE_BINARY_DIR}/dat/dlb.lst
	  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/dat
	  # TODO: Lots of commands go here...
	  COMMENT "Packaging via DLB"
	)

	add_custom_target(PackageDLB ALL
	  DEPENDS ${CMAKE_BINARY_DIR}/dat/dlb.lst
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
