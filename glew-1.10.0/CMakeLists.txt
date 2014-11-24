cmake_minimum_required(VERSION 2.8)

add_library(glew src/glew.c)
include_directories(include)
add_definitions(-DGLEW_NO_GLU)

install(TARGETS glew DESTINATION lib)
install(FILES include/GL/glew.h DESTINATION include/GL)
