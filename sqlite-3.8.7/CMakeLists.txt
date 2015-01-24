cmake_minimum_required(VERSION 2.8)

add_library(sqlite sqlite3.c)

install(FILES sqlite3.h DESTINATION include)
