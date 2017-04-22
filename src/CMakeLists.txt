

if(MSVC)
  file(WRITE ${CMAKE_BINARY_DIR}/src/nhdefkey.def "\
LIBRARY\n\
EXPORTS\n\
   ProcessKeystroke\n\
   NHkbhit\n\
   CheckInput\n\
   SourceWhere\n\
   SourceAuthor\n\
   KeyHandlerName\n\
")
  add_library(nhdefkey SHARED 
      ../sys/winnt/nhdefkey.c
      ${CMAKE_BINARY_DIR}/src/nhdefkey.def)
  set_target_properties(nhdefkey PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG ${STAGING_DIRECTORY})
  set_target_properties(nhdefkey PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE ${STAGING_DIRECTORY})
  set_target_properties(nhdefkey PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${STAGING_DIRECTORY})
  install(TARGETS nhdefkey DESTINATION .)
endif()

file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/dat)
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/src)

############################################
### Generate source files using makedefs ###
############################################

add_executable(makedefs ../util/makedefs.c monst.c objects.c)

set(MAKEDEFS_OUTPUTS "")
function(run_makedefs flag subfolder depends)
  # Copy dependencies from source tree into build tree
  set(depends_bin "")
  foreach(DEPEND ${depends})
    configure_file(${CMAKE_SOURCE_DIR}/${DEPEND} ${CMAKE_BINARY_DIR}/${DEPEND} COPYONLY)
    set(depends_bin ${depends_bin} ${CMAKE_BINARY_DIR}/${DEPEND})
  endforeach()
  # message(${ARGN})
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

###############
### levcomp ###
###############

add_executable(levcomp
  alloc.c
  decl.c
  drawing.c
  ${CMAKE_BINARY_DIR}/util/lev_lex.c
  ../util/lev_main.c
  ${CMAKE_BINARY_DIR}/util/lev_yacc.c
  monst.c
  objects.c
  ../util/panic.c
)

# Don't build levcomp until pm.h has been generated
add_custom_target(LevCompHeaders
    DEPENDS ${CMAKE_BINARY_DIR}/include/date.h
    DEPENDS ${CMAKE_BINARY_DIR}/include/onames.h
    DEPENDS ${CMAKE_BINARY_DIR}/include/pm.h
)
add_dependencies(levcomp LevCompHeaders)

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


set(NH_SRCS
  allmain.c
  alloc.c
  apply.c
  artifact.c
  attrib.c
  ball.c
  bones.c
  botl.c
  cmd.c
  ../sys/share/cppregex.cpp
  dbridge.c
  decl.c
  detect.c
  dig.c
  display.c
  dlb.c
  do.c
  do_name.c
  do_wear.c
  dog.c
  dogmove.c
  dokick.c
  dothrow.c
  drawing.c
  dungeon.c
  eat.c
  end.c
  engrave.c
  exper.c
  explode.c
  extralev.c
  files.c
  fountain.c
  ../win/tty/getline.c
  hack.c
  hacklib.c
  invent.c
  light.c
  lock.c
  mail.c
  makemon.c
  mapglyph.c
  mcastu.c
  mhitm.c
  mhitu.c
  minion.c
  mklev.c
  mkmap.c
  mkmaze.c
  mkobj.c
  mkroom.c
  mon.c
  mondata.c
  monmove.c
  monst.c
  ${CMAKE_BINARY_DIR}/src/monstr.c
  mplayer.c
  mthrowu.c
  muse.c
  music.c
  ../sys/share/nhlan.c
  ../sys/winnt/ntsound.c
  ../sys/winnt/nttty.c
  o_init.c
  objects.c
  objnam.c
  options.c
  pager.c
  ../sys/share/pcmain.c
  ../sys/share/pcsys.c
  ../sys/share/pcunix.c
  pickup.c
  pline.c
  polyself.c
  potion.c
  pray.c
  priest.c
  quest.c
  questpgr.c
  ../sys/share/random.c
  read.c
  rect.c
  region.c
  restore.c
  rip.c
  rnd.c
  role.c
  rumors.c
  save.c
  shk.c
  shknam.c
  sit.c
  sounds.c
  sp_lev.c
  spell.c
  steal.c
  steed.c
  ../sys/winnt/stubs.c
  sys.c
  teleport.c
  ${CMAKE_BINARY_DIR}/src/tile.c
  timeout.c
  ../win/tty/topl.c
  topten.c
  track.c
  trap.c
  u_init.c
  uhitm.c
  vault.c
  version.c
  vision.c
  weapon.c
  were.c
  wield.c
  windows.c
  ../sys/winnt/winnt.c
  ../win/tty/wintty.c
  wizard.c
  worm.c
  worn.c
  write.c
  zap.c
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


add_executable(NetHack ${NH_SRCS})
target_link_libraries(NetHack winmm.lib) # Avoid sndPlaySound link error
install(TARGETS NetHack DESTINATION .)

install(FILES
	../winnt/sysconf
	../winnt/defaults.nh
	../doc/Guidebook.txt
	../dat/license	
	DESTINATION .)

# Allow running NetHack from build folder
set_target_properties(NetHack PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG ${STAGING_DIRECTORY})
set_target_properties(NetHack PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE ${STAGING_DIRECTORY})
set_target_properties(NetHack PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${STAGING_DIRECTORY})
if(MSVC)
  configure_file(../sys/winnt/sysconf ${STAGING_DIRECTORY}/sysconf)
endif()
