cmake_minimum_required(VERSION 2.8)

add_definitions(-DLUA_COMPAT_ALL)

set(LUA_PUBLIC_HEADERS lapi.h     ldebug.h  llex.h     lopcodes.h  ltable.h
lualib.h lauxlib.h  ldo.h     llimits.h  lparser.h   ltm.h      lundump.h
lcode.h    lfunc.h   lmem.h     lstate.h    luaconf.h  lvm.h lctype.h   lgc.h
lobject.h  lstring.h   lua.h      lzio.h)

set(LUA_SRC lapi.c lcode.c lctype.c ldebug.c ldo.c ldump.c lfunc.c lgc.c llex.c
lmem.c lobject.c lopcodes.c lparser.c lstate.c lstring.c ltable.c ltm.c
lundump.c lvm.c lzio.c lauxlib.c lbaselib.c lbitlib.c lcorolib.c ldblib.c
liolib.c lmathlib.c loslib.c lstrlib.c ltablib.c loadlib.c linit.c)

add_library(lua ${LUA_SRC})

install(TARGETS lua DESTINATION lib)
install(FILES ${LUA_PUBLIC_HEADERS} DESTINATION include/lua)
