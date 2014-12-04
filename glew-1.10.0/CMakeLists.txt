cmake_minimum_required(VERSION 2.8)

add_library(GLEW src/glew.c)
include_directories(include)
add_definitions(-DGLEW_NO_GLU)

install(FILES include/GL/glew.h DESTINATION include/GL)
install(FILES include/GL/glxew.h DESTINATION include/GL)
