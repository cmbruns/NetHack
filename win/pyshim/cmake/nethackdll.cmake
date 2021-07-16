# Create nethack DLL shared library for use in python wrapper

add_compile_definitions(WIN32CON DLB MSWIN_GRAPHICS TILES SAFEPROCS _LIB)

set(NHDLL_SRCS
    "${SRC_DIR}/allmain.c"
    "${SRC_DIR}/alloc.c"
    "${SRC_DIR}/apply.c"
    "${SRC_DIR}/artifact.c"
    "${SRC_DIR}/attrib.c"
    "${SRC_DIR}/ball.c"
    "${SRC_DIR}/bones.c"
    "${SRC_DIR}/botl.c"
    "${SRC_DIR}/cmd.c"
    "${SRC_DIR}/dbridge.c"
    "${SRC_DIR}/decl.c"
    "${SRC_DIR}/detect.c"
    "${SRC_DIR}/dig.c"
    "${SRC_DIR}/display.c"
    "${SRC_DIR}/dlb.c"
    "${SRC_DIR}/do.c"
    "${SRC_DIR}/dog.c"
    "${SRC_DIR}/dogmove.c"
    "${SRC_DIR}/dokick.c"
    "${SRC_DIR}/dothrow.c"
    "${SRC_DIR}/do_name.c"
    "${SRC_DIR}/do_wear.c"
    "${SRC_DIR}/drawing.c"
    "${SRC_DIR}/dungeon.c"
    "${SRC_DIR}/eat.c"
    "${SRC_DIR}/end.c"
    "${SRC_DIR}/engrave.c"
    "${SRC_DIR}/exper.c"
    "${SRC_DIR}/explode.c"
    "${SRC_DIR}/extralev.c"
    "${SRC_DIR}/files.c"
    "${SRC_DIR}/fountain.c"
    "${SRC_DIR}/hack.c"
    "${SRC_DIR}/hacklib.c"
    "${SRC_DIR}/invent.c"
    "${SRC_DIR}/isaac64.c"
    "${SRC_DIR}/light.c"
    "${SRC_DIR}/lock.c"
    "${SRC_DIR}/mail.c"
    "${SRC_DIR}/makemon.c"
    "${SRC_DIR}/mapglyph.c"
    "${SRC_DIR}/mcastu.c"
    "${SRC_DIR}/mhitm.c"
    "${SRC_DIR}/mhitu.c"
    "${SRC_DIR}/minion.c"
    "${SRC_DIR}/mklev.c"
    "${SRC_DIR}/mkmap.c"
    "${SRC_DIR}/mkmaze.c"
    "${SRC_DIR}/mkobj.c"
    "${SRC_DIR}/mkroom.c"
    "${SRC_DIR}/mon.c"
    "${SRC_DIR}/mondata.c"
    "${SRC_DIR}/monmove.c"
    "${SRC_DIR}/monst.c"
    "${SRC_DIR}/mplayer.c"
    "${SRC_DIR}/mthrowu.c"
    "${SRC_DIR}/muse.c"
    "${SRC_DIR}/music.c"
    "${SRC_DIR}/objects.c"
    "${SRC_DIR}/objnam.c"
    "${SRC_DIR}/options.c"
    "${SRC_DIR}/o_init.c"
    "${SRC_DIR}/pager.c"
    "${SRC_DIR}/pickup.c"
    "${SRC_DIR}/pline.c"
    "${SRC_DIR}/polyself.c"
    "${SRC_DIR}/potion.c"
    "${SRC_DIR}/pray.c"
    "${SRC_DIR}/priest.c"
    "${SRC_DIR}/quest.c"
    "${SRC_DIR}/questpgr.c"
    "${SRC_DIR}/read.c"
    "${SRC_DIR}/rect.c"
    "${SRC_DIR}/region.c"
    "${SRC_DIR}/restore.c"
    "${SRC_DIR}/rip.c"
    "${SRC_DIR}/rnd.c"
    "${SRC_DIR}/role.c"
    "${SRC_DIR}/rumors.c"
    "${SRC_DIR}/save.c"
    "${SRC_DIR}/shk.c"
    "${SRC_DIR}/shknam.c"
    "${SRC_DIR}/sit.c"
    "${SRC_DIR}/sounds.c"
    "${SRC_DIR}/spell.c"
    "${SRC_DIR}/sp_lev.c"
    "${SRC_DIR}/steal.c"
    "${SRC_DIR}/steed.c"
    "${SRC_DIR}/sys.c"
    "${SRC_DIR}/teleport.c"
    "${SRC_DIR}/tile.c"
    "${SRC_DIR}/timeout.c"
    "${SRC_DIR}/topten.c"
    "${SRC_DIR}/track.c"
    "${SRC_DIR}/trap.c"
    "${SRC_DIR}/uhitm.c"
    "${SRC_DIR}/u_init.c"
    "${SRC_DIR}/vault.c"
    "${SRC_DIR}/version.c"
    "${SRC_DIR}/vision.c"
    "${SRC_DIR}/weapon.c"
    "${SRC_DIR}/were.c"
    "${SRC_DIR}/wield.c"
    "${SRC_DIR}/windows.c"
    "${SRC_DIR}/wizard.c"
    "${SRC_DIR}/worm.c"
    "${SRC_DIR}/worn.c"
    "${SRC_DIR}/write.c"
    "${SRC_DIR}/zap.c"
    "${SYS_SHARE_DIR}/cppregex.cpp"
    "${SYS_SHARE_DIR}/nhlan.c"
    "${SYS_SHARE_DIR}/random.c"
    "${SYS_WINNT_DIR}/ntsound.c"
    "${SYS_WINNT_DIR}/nttty.c"
    "${SYS_WINNT_DIR}/stubs.c"
    "${SYS_WINNT_DIR}/windmain.c"
    "${SYS_WINNT_DIR}/winnt.c"
    "${WIN_SHARE_DIR}/safeproc.c"
    "${WIN_TTY_DIR}/getline.c"
    "${WIN_TTY_DIR}/topl.c"
    "${WIN_TTY_DIR}/wintty.c"
)

set(NHDLL_HDRS
    "${INC_DIR}/align.h"
    "${INC_DIR}/artifact.h"
    "${INC_DIR}/artilist.h"
    "${INC_DIR}/attrib.h"
    "${INC_DIR}/botl.h"
    "${INC_DIR}/color.h"
    "${INC_DIR}/config.h"
    "${INC_DIR}/config1.h"
    "${INC_DIR}/context.h"
    "${INC_DIR}/coord.h"
    "${INC_DIR}/date.h"
    "${INC_DIR}/decl.h"
    "${INC_DIR}/display.h"
    "${INC_DIR}/dlb.h"
    "${INC_DIR}/dungeon.h"
    "${INC_DIR}/engrave.h"
    "${INC_DIR}/extern.h"
    "${INC_DIR}/flag.h"
    "${INC_DIR}/func_tab.h"
    "${INC_DIR}/global.h"
    "${INC_DIR}/hack.h"
    "${INC_DIR}/isaac64.h"
    "${INC_DIR}/lev.h"
    "${INC_DIR}/mextra.h"
    "${INC_DIR}/mfndpos.h"
    "${INC_DIR}/mkroom.h"
    "${INC_DIR}/monattk.h"
    "${INC_DIR}/mondata.h"
    "${INC_DIR}/monflag.h"
    "${INC_DIR}/monst.h"
    "${INC_DIR}/monsym.h"
    "${INC_DIR}/ntconf.h"
    "${INC_DIR}/obj.h"
    "${INC_DIR}/objclass.h"
    "${INC_DIR}/onames.h"
    "${INC_DIR}/patchlevel.h"
    "${INC_DIR}/permonst.h"
    "${INC_DIR}/pm.h"
    "${INC_DIR}/prop.h"
    "${INC_DIR}/qtext.h"
    "${INC_DIR}/quest.h"
    "${INC_DIR}/rect.h"
    "${INC_DIR}/region.h"
    "${INC_DIR}/rm.h"
    "${INC_DIR}/skills.h"
    "${INC_DIR}/spell.h"
    "${INC_DIR}/sp_lev.h"
    "${INC_DIR}/timeout.h"
    "${INC_DIR}/tradstdc.h"
    "${INC_DIR}/trap.h"
    "${INC_DIR}/vision.h"
    "${INC_DIR}/winprocs.h"
    "${INC_DIR}/wintty.h"
    "${INC_DIR}/wintype.h"
    "${INC_DIR}/you.h"
    "${INC_DIR}/youprop.h"
    "${WIN_WIN32_DIR}/nhresource.h"
    "${WIN_CURS_DIR}/cursdial.h"
    "${WIN_CURS_DIR}/cursinit.h"
    "${WIN_CURS_DIR}/cursinvt.h"
    "${WIN_CURS_DIR}/cursmesg.h"
    "${WIN_CURS_DIR}/cursmisc.h"
    "${WIN_CURS_DIR}/cursstat.h"
    "${WIN_CURS_DIR}/curswins.h"
)

set_property(SOURCE "${SYS_WINNT_DIR}/stubs.c" APPEND PROPERTY COMPILE_DEFINITIONS GUISTUB)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${BIN_DIR}/Release/${PLATFORM}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${BIN_DIR}/Debug/${PLATFORM}")

add_library(NetHackDLL SHARED ${NHDLL_SRCS} ${NHDLL_HDRS})
target_link_libraries(NetHackDLL bcrypt winmm)

source_group("Header Files" FILES $NHDLL_HDRS "")
source_group("Source Files" FILES $NHDLL_SRCS "")
