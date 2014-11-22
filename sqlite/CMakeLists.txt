cmake_minimum_required(VERSION 2.8)

add_library(sqlite sqlite3.c)

install(TARGETS sqlite DESTINATION external-deps/sqlite/lib/${CMAKE_SYSTEM_NAME}/${ARCH})
install(FILES sqlite3.h DESTINATION external-deps/sqlite/include/sqlite)
