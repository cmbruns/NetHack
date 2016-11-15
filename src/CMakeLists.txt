
if(MSVC)
  add_library(nhdefkey SHARED ../sys/winnt/nhdefkey.c)
endif()
install(TARGETS nhdefkey DESTINATION bin)
