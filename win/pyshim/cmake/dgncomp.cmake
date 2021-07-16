
# dgncomp utility program

set(DGNCOMP_SRCS
     "${SRC_DIR}/alloc.c"
     "${SYS_SHARE_DIR}/dgn_lex.c"
     "${UTIL_DIR}/dgn_main.c"
     "${UTIL_DIR}/dgn_main.c"
     "${SYS_SHARE_DIR}/dgn_yacc.c"
     "${UTIL_DIR}/panic.c"
)

set(DGNCOMP_HDRS
    "${INC_DIR}/align.h"
    "${INC_DIR}/attrib.h"
    "${INC_DIR}/color.h"
    "${INC_DIR}/config.h"
    "${INC_DIR}/config1.h"
    "${INC_DIR}/context.h"
    "${INC_DIR}/coord.h"
    "${INC_DIR}/decl.h"
    "${INC_DIR}/dgn_comp.h"
    "${INC_DIR}/dgn_file.h"
    "${INC_DIR}/display.h"
    "${INC_DIR}/dungeon.h"
    "${INC_DIR}/engrave.h"
    "${INC_DIR}/flag.h"
    "${INC_DIR}/global.h"
    "${INC_DIR}/mkroom.h"
    "${INC_DIR}/monattk.h"
    "${INC_DIR}/monst.h"
    "${INC_DIR}/monsym.h"
    "${INC_DIR}/ntconf.h"
    "${INC_DIR}/obj.h"
    "${INC_DIR}/objclass.h"
    "${INC_DIR}/onames.h"
    "${INC_DIR}/permonst.h"
    "${INC_DIR}/pm.h"
    "${INC_DIR}/prop.h"
    "${INC_DIR}/quest.h"
    "${INC_DIR}/rect.h"
    "${INC_DIR}/region.h"
    "${INC_DIR}/rm.h"
    "${INC_DIR}/skills.h"
    "${INC_DIR}/spell.h"
    "${INC_DIR}/timeout.h"
    "${INC_DIR}/tradstdc.h"
    "${INC_DIR}/trampoli.h"
    "${INC_DIR}/trap.h"
    "${INC_DIR}/vision.h"
    "${INC_DIR}/winprocs.h"
    "${INC_DIR}/wintty.h"
    "${INC_DIR}/wintype.h"
    "${INC_DIR}/you.h"
    "${INC_DIR}/youprop.h"
)

add_executable(dgncomp ${DGNCOMP_SRCS} ${DGNCOMP_HDRS})

source_group("Header Files" FILES $DGNCOMP_HDRS "")
source_group("Source Files" FILES $DGNCOMP_SRCS "")
